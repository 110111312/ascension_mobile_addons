#!/usr/bin/env python3
"""
Crawl the Wayback Machine snapshot of wowprogramming.com (2010-07-26, WoW 3.x era)
and store a clean, offline-browsable API reference under reference/wowprogramming/.

Uses the Wayback `id_` modifier to fetch the RAW archived response (no toolbar/
wrapper), which is faster and smaller, and keeps the site's original relative
`/docs/...` links (trivial to rewrite to local paths).

Scope: the /docs/ tree only (API functions, events, widgets + methods, cvars,
types, flags, secure_template, scripts). PmWiki action suffixes (.rss/.edit/.login
...) are filtered out because real doc page names contain no '.'.

- Dynamic frontier: section index pages are fetched first; each widget page is
  fetched in the pool and enqueues its method sub-pages.
- Rewrites internal /docs/ links to local relative paths for offline browsing.
- Resumable: skips already-downloaded leaf pages; widget pages are always
  re-fetched (cheap, ~38) so their method sub-pages get re-enqueued.
"""
import os, re, sys, time, ssl, queue, threading
import urllib.request, urllib.error

TS = "20100726112636"
WAYBACK = "https://web.archive.org"
ORIGIN = "http://wowprogramming.com"
OUT_ROOT = r"C:\W\ascension_mobile_addons\reference\wowprogramming\crawl_resource\wowprogramming_docs"
FRONTIER_DUMP = os.path.join(OUT_ROOT, "_frontier.txt")
MAX_WORKERS = 2
TIMEOUT = 25
MAX_RETRY = 3
MIN_REQ_INTERVAL = 0.9   # space request starts to stay under Wayback rate limit
BURST_N = 180            # requests per burst before a cooldown
BURST_PAUSE = 180.0       # cooldown seconds to reset Wayback burst budget

_ctx = ssl.create_default_context()
_ctx.check_hostname = False
_ctx.verify_mode = ssl.CERT_NONE
UA = "Mozilla/5.0 (compatible; WPRefCrawler/1.0)"

_rl_lock = threading.Lock()
_last_req = [0.0]
_req_count = [0]
_pause_until = [0.0]

def _pace():
    sleep_for = 0.0
    with _rl_lock:
        now = time.time()
        if now < _pause_until[0]:
            sleep_for = _pause_until[0] - now
        else:
            sleep_for = MIN_REQ_INTERVAL - (now - _last_req[0])
            if sleep_for < 0:
                sleep_for = 0.0
            _last_req[0] = now + sleep_for
            _req_count[0] += 1
            if _req_count[0] >= BURST_N:
                _req_count[0] = 0
                _pause_until[0] = now + sleep_for + BURST_PAUSE
    if sleep_for > 0:
        time.sleep(sleep_for)

# original-site links: relative "/docs/..." or absolute "http[s]://wowprogramming.com/docs/..."
LINK_RE = re.compile(r'''(?:href|src)\s*=\s*"(?:/web/\d+(?:[a-z_]*)?/(?:https?://)?(?:www\.)?wowprogramming\.com(?::80)?|(?:https?://)?(?:www\.)?wowprogramming\.com(?::80)?)?(/docs/[A-Za-z0-9_./-]*?)(?:[?#][^"]*)?"''')
# also catch pure relative /docs links without host (already covered, but keep explicit)
REL_DOCS_RE = re.compile(r'''href="/docs/([A-Za-z0-9_./-]*)(?:[?#][^"]*)?"''')

def doc_paths_from(html_bytes):
    """Extract accepted /docs/ paths from a raw (id_) page."""
    if not html_bytes:
        return set()
    s = html_bytes.decode('utf-8', errors='replace')
    out = set()
    for m in LINK_RE.finditer(s):
        p = m.group(1)
        if is_accepted(p):
            out.add(p)
    for m in REL_DOCS_RE.finditer(s):
        p = '/docs/' + m.group(1)
        if is_accepted(p):
            out.add(p)
    return out

def is_accepted(p):
    """Accept /docs/ paths where no segment contains a '.' (drops .rss/.edit)."""
    if not p.startswith('/docs'):
        return False
    p = p.split('#', 1)[0].split('?', 1)[0].rstrip('/')
    if p in ('/docs', '/docs/'):
        return True
    rest = p[len('/docs'):].lstrip('/')
    if not rest:
        return True
    segs = rest.split('/')
    # widgets: section/widget/method (<=3); other sections: section/leaf (<=2)
    maxd = 3 if segs[0] == 'widgets' else 2
    if len(segs) > maxd:
        return False
    for s in segs:
        if not s or '.' in s:
            return False
    return True

# --- URL helpers -----------------------------------------------------------

def wb_url_for(path):
    return f"{WAYBACK}/web/{TS}id_/{ORIGIN}{path}"

def local_rel_for(orig_path):
    p = orig_path.split('#', 1)[0].split('?', 1)[0]
    if p in ('', '/'):
        return 'index.html'
    if p in ('/docs', '/docs/'):
        return 'docs/index.html'
    p = p.lstrip('/')
    if p.endswith('/'):
        p += 'index.html'
    if '.' not in os.path.basename(p):
        p += '.html'
    return p

def abs_local(orig_path):
    return os.path.join(OUT_ROOT, local_rel_for(orig_path).replace('/', os.sep))

def _is_stub(path):
    """True if the file is a 'missing snapshot' placeholder (needs retry)."""
    try:
        with open(path, 'r', encoding='utf-8', errors='replace') as f:
            return f.read(60).lstrip().startswith('<!-- missing snapshot')
    except Exception:
        return False

def rel_link(from_path, to_path):
    frm = local_rel_for(from_path).split('#', 1)[0]
    to = local_rel_for(to_path)
    return os.path.relpath(to, os.path.dirname(frm)).replace(os.sep, '/')

# --- fetch -----------------------------------------------------------------

def fetch(url, tries=MAX_RETRY):
    for i in range(tries):
        _pace()
        try:
            req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept": "*/*"})
            with urllib.request.urlopen(req, timeout=TIMEOUT, context=_ctx) as r:
                if r.status == 200:
                    return r.read()
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return None
            if e.code in (429, 500, 502, 503, 504):
                time.sleep(min(2 ** i, 8) + 0.5)
                continue
            return None
        except Exception:
            time.sleep(min(2 ** i, 8) + 0.2)
    return None

# --- clean -----------------------------------------------------------------

MIN_CSS = (
    "<style>"
    "body{font-family:Verdana,Arial,sans-serif;max-width:1000px;margin:1em auto;"
    "padding:0 1em;color:#222;background:#fff;line-height:1.45}"
    "a{color:#1659a0;} a:visited{color:#6a4a9a;}"
    "pre,code{background:#f4f4f4;padding:1px 4px;border-radius:3px;"
    "font-family:Consolas,monospace;}"
    "pre{padding:.6em;overflow:auto;}"
    "table{border-collapse:collapse;} th,td{border:1px solid #ccc;padding:3px 7px;}"
    "th{background:#eee;} h1,h2,h3{color:#333;} .deprecated{color:#9a3a3a;}"
    "hr{border:none;border-top:1px solid #ccc;} img{max-width:100%;}"
    "</style>"
)

# rewrite href/src pointing to /docs/... (relative or absolute host) -> local rel
_REWRITE_RE = re.compile(
    r'''((?:href|src)\s*=\s*")'''
    r'''(?:/web/\d+(?:[a-z_]*)?/(?:https?://)?(?:www\.)?wowprogramming\.com(?::80)?|'''
    r'''(?:https?://)?(?:www\.)?wowprogramming\.com(?::80)?)?'''
    r'''(/docs/[A-Za-z0-9_./-]*)([?#][^"]*)?(")''',
    re.I)

def clean(html_bytes, from_path):
    s = html_bytes.decode('utf-8', errors='replace')

    def repl(m):
        pre, opath, frag, q = m.group(1), m.group(2), m.group(3) or '', m.group(4)
        p0 = opath.split('#', 1)[0].split('?', 1)[0].rstrip('/')
        try:
            return pre + rel_link(from_path, p0) + frag + q
        except Exception:
            return m.group(0)
    s = _REWRITE_RE.sub(repl, s)

    if re.search(r'<head[^>]*>', s, re.I):
        s = re.sub(r'(<head[^>]*>)', r'\1' + MIN_CSS, s, count=1, flags=re.I)
    return s

# --- discovery (cheap index pages only) -----------------------------------

INDEX_PAGES = [
    "/docs/", "/docs", "/docs/api", "/docs/api_categories", "/docs/api_types",
    "/docs/api_flags", "/docs/events", "/docs/cvars", "/docs/widgets",
    "/docs/widgets_hierarchy", "/docs/secure_template", "/docs/scripts",
]

def _fetch_index(path):
    """Fetch an index page, retrying until it returns content with doc links."""
    for attempt in range(6):
        b = fetch(wb_url_for(path))
        if b:
            got = doc_paths_from(b)
            if got or path in ('/docs/secure_template', '/docs/scripts'):
                return b, got
            # got 0 links but bytes present -> maybe a thin/error page; retry
        time.sleep(1.0 + attempt)
    return b, (doc_paths_from(b) if b else set())

def discover_seed():
    seed = set()
    for p in INDEX_PAGES:
        b, got = _fetch_index(p)
        seed |= got
        seed.add(p)
        print(f"  index {p}: +{len(got)} (seed={len(seed)})"
              + ("  [RETRIED/EMPTY]" if (b is None or len(got) == 0) else ""),
              flush=True)
    seed = {x for x in seed if x.startswith('/docs')}
    return sorted(seed)

# --- download phase (dynamic frontier) ------------------------------------

WIDGET_PAGE_RE = re.compile(r'^/docs/widgets/[^/]+$')
WIDGET_METHOD_RE = re.compile(r'^/docs/widgets/[^/]+/[^/]+$')

def main():
    os.makedirs(OUT_ROOT, exist_ok=True)
    print("Phase 1: discovery (index pages) ...", flush=True)
    seed = discover_seed()
    print(f"discovered seed: {len(seed)} pages (incl. widget pages to expand)", flush=True)

    q = queue.Queue()
    seen = set()
    lock = threading.Lock()
    remaining = [0]
    done = [0]
    skipped = [0]
    missing = [0]
    methods_added = [0]
    t0 = time.time()

    def enqueue(p):
        with lock:
            if p in seen:
                return
            seen.add(p)
            remaining[0] += 1
            q.put(p)

    for p in seed:
        enqueue(p)

    def save_clean(out, b, path):
        try:
            cleaned = clean(b, path)
        except Exception:
            cleaned = b.decode('utf-8', 'replace')
        os.makedirs(os.path.dirname(out), exist_ok=True)
        with open(out, 'w', encoding='utf-8') as f:
            f.write(cleaned)

    def process(path):
        out = abs_local(path)
        if WIDGET_PAGE_RE.match(path):
            b = fetch(wb_url_for(path))
            if b is None:
                os.makedirs(os.path.dirname(out), exist_ok=True)
                with open(out, 'w', encoding='utf-8') as f:
                    f.write(f"<!-- missing snapshot for {path} -->\n")
                with lock:
                    missing[0] += 1
                return
            save_clean(out, b, path)
            newp = 0
            for mp in doc_paths_from(b):
                if WIDGET_METHOD_RE.match(mp):
                    before = len(seen)
                    enqueue(mp)
                    if len(seen) > before:
                        newp += 1
            if newp:
                with lock:
                    methods_added[0] += newp
            return
        if os.path.exists(out) and os.path.getsize(out) > 0 and not _is_stub(out):
            with lock:
                skipped[0] += 1
            return
        b = fetch(wb_url_for(path))
        if b is None:
            os.makedirs(os.path.dirname(out), exist_ok=True)
            with open(out, 'w', encoding='utf-8') as f:
                f.write(f"<!-- missing snapshot for {path} -->\n")
            with lock:
                missing[0] += 1
            return
        save_clean(out, b, path)

    def worker():
        while True:
            try:
                path = q.get(timeout=3)
            except queue.Empty:
                if remaining[0] == 0:
                    return
                continue
            try:
                process(path)
            except Exception:
                with lock:
                    missing[0] += 1
            with lock:
                remaining[0] -= 1
                done[0] += 1
                d = done[0]; rem = remaining[0]; mi = missing[0]; ma = methods_added[0]
            if d % 100 == 0:
                el = time.time() - t0
                rate = d / el if el else 0
                print(f"[{d} done|{rem} left|{ma} methods|{mi} miss] "
                      f"({rate:.1f}/s, {el/60:.1f}m)", flush=True)

    workers = [threading.Thread(target=worker, daemon=True) for _ in range(MAX_WORKERS)]
    for w in workers:
        w.start()
    print(f"Phase 2: downloading (dynamic frontier, {MAX_WORKERS} workers) ...", flush=True)
    for w in workers:
        w.join()
    el = time.time() - t0
    with lock:
        tot = len(seen)
    print(f"DONE: {done[0]} processed, {skipped[0]} skipped(existing), "
          f"{missing[0]} missing, {methods_added[0]} widget methods added; "
          f"total unique={tot} in {el/60:.1f}m", flush=True)
    with open(FRONTIER_DUMP, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sorted(seen)) + '\n')

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\ninterrupted", flush=True)