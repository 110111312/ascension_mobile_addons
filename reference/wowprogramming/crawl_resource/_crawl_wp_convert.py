#!/usr/bin/env python3
"""
Convert the crawled wowprogramming.com HTML pages into clean, AI-agent-friendly
markdown reference files.

Output: reference/wowprogramming/markdown/
  - api.md          (all API functions)
  - events.md       (all events)
  - widgets.md      (widget types + their methods)
  - scripts.md      (script handlers)
  - index.md        (master index with counts)

Each entry is structured markdown with clear section headers so an AI agent
can parse and search them efficiently.
"""

import os
import re
import html
from pathlib import Path

ROOT = Path("reference/wowprogramming/crawl_resource")
OUT = Path("reference/wowprogramming/markdown")
DOCS = ROOT / "wowprogramming_docs"

def strip_tags(text, keep_code=True):
    """Remove HTML tags, decode entities, collapse whitespace."""
    text = re.sub(r'<br\s*/?>', '\n', text)
    text = re.sub(r'<li[^>]*>', '\n  - ', text)
    text = re.sub(r'</?(?:ul|ol)\s*>', '\n', text)
    text = re.sub(r'</?(?:p|div|h[1-6]|hr)\s*/?>', '\n', text)
    if keep_code:
        text = re.sub(r'<code[^>]*>', '`', text)
        text = text.replace('</code>', '`')
    else:
        text = re.sub(r'</?code[^>]*>', '', text)
    text = re.sub(r'<a\s[^>]*href=["\']([^"\']*)["\'][^>]*>(.*?)</a>', r'\2', text, flags=re.DOTALL)
    text = re.sub(r'<[^>]+>', '', text)
    text = html.unescape(text)
    text = re.sub(r'\n{3,}', '\n\n', text)
    text = re.sub(r'[ \t]+', ' ', text)
    return text.strip()

def extract_content_div(html_text):
    """Extract the #content div from the HTML page."""
    m = re.search(r'<div\s+id=["\']content["\']>(.*?)</div>\s*<div\s+id=[\'"]footer',
                  html_text, re.DOTALL)
    if m:
        return m.group(1)
    return ""

def is_stub(html_text):
    return '<!-- missing snapshot' in html_text

def is_empty_node(content):
    return 'does not exist' in content[:500]

def extract_api_desc(content):
    m = re.search(r'<div\s+class=["\']api-desc["\']>(.*?)</div>', content, re.DOTALL)
    return strip_tags(m.group(1)) if m else ""

def extract_signature(content):
    m = re.search(r'<div\s+class=["\']signature["\']>(.*?)</div>', content, re.DOTALL)
    if not m:
        return ""
    sig = m.group(1)
    # Some pages have "Signature:" label inside the signature div
    sig = re.sub(r'Signature:\s*', '', sig, flags=re.IGNORECASE)
    sig = strip_tags(sig, keep_code=False)
    return sig.strip()

def extract_section(content, label_pattern):
    """Extract a labeled section (Arguments, Returns, etc.) as a list of items."""
    # Find the label (allow trailing colon)
    pattern = rf'<p\s+class=["\']label["\'][^>]*>{label_pattern}:?</p>(.*?)(?=<p\s+class=["\']label|<div\s+class=["\']flags|</div>\s*$|$)'
    m = re.search(pattern, content, re.DOTALL | re.IGNORECASE)
    if not m:
        return []
    section_html = m.group(1)
    # Extract list items
    items = []
    for li_match in re.finditer(r'<li[^>]*>(.*?)</li>', section_html, re.DOTALL):
        item_text = strip_tags(li_match.group(1))
        items.append(item_text)
    return items

def extract_flags(content):
    m = re.search(r'<div\s+class=["\']flags["\']>(.*?)</div>\s*</div>', content, re.DOTALL)
    if not m:
        return []
    flags_html = m.group(1)
    flags = []
    for div_match in re.finditer(r'<div\s+class=["\'](?:notice|warning|info)["\']>(.*?)</div>', flags_html, re.DOTALL):
        flags.append(strip_tags(div_match.group(1)))
    return flags

def extract_see_also(content):
    """Extract 'See also' links."""
    m = re.search(r'See also\s*(.*?)(?=<p\s+class=["\']label|$)', content, re.DOTALL)
    if not m:
        return []
    text = strip_tags(m.group(1))
    if text:
        return [t.strip() for t in text.split(',') if t.strip()]
    return []

def extract_widget_methods(content):
    """Extract methods listing from widget pages."""
    m = re.search(r'<h3>Methods</h3>(.*?)(?:<h3>|</div>\s*$|$)', content, re.DOTALL)
    if not m:
        return []
    methods_html = m.group(1)
    methods = []
    for li_match in re.finditer(r'<li>(.*?)</li>', methods_html, re.DOTALL):
        item = li_match.group(1)
        # Extract signature text and description
        text = strip_tags(item)
        if text:
            methods.append(text)
    return methods

def extract_widget_scripts(content):
    """Extract script handlers listing from widget pages."""
    m = re.search(r'<h3>Script Handlers</h3>(.*?)(?:</div>\s*$|$)', content, re.DOTALL)
    if not m:
        return []
    scripts_html = m.group(1)
    scripts = []
    for li_match in re.finditer(r'<li>(.*?)</li>', scripts_html, re.DOTALL):
        text = strip_tags(li_match.group(1))
        if text:
            scripts.append(text)
    return scripts

def convert_api_page(name, html_text):
    """Convert an API function page to markdown."""
    if is_stub(html_text):
        return f"## {name}\n\n_No snapshot available (page did not exist in archive)._\n"
    content = extract_content_div(html_text)
    if not content or is_empty_node(content):
        return f"## {name}\n\n_No content available._\n"

    desc = extract_api_desc(content)
    sig = extract_signature(content)
    args = extract_section(content, r'Arguments')
    returns = extract_section(content, r'Returns')
    flags = extract_flags(content)
    see_also = extract_see_also(content)

    lines = [f"## {name}", ""]
    if desc:
        lines.append(desc)
        lines.append("")
    if sig:
        lines.append(f"**Signature:** `{sig}`")
        lines.append("")
    if args:
        lines.append("**Arguments:**")
        for a in args:
            lines.append(f"- {a}")
        lines.append("")
    if returns:
        lines.append("**Returns:**")
        for r in returns:
            lines.append(f"- {r}")
        lines.append("")
    if flags:
        for f in flags:
            lines.append(f"> **Note:** {f}")
        lines.append("")
    if see_also:
        lines.append(f"**See also:** {', '.join(see_also)}")
        lines.append("")
    return '\n'.join(lines)

def convert_event_page(name, html_text):
    """Convert an event page to markdown."""
    if is_stub(html_text):
        return f"## {name}\n\n_No snapshot available._\n"
    content = extract_content_div(html_text)
    if not content or is_empty_node(content):
        return f"## {name}\n\n_No content available._\n"

    desc = extract_api_desc(content)
    sig = extract_signature(content)
    args = extract_section(content, r'Arguments')
    payload = extract_section(content, r'Payload')
    flags = extract_flags(content)

    lines = [f"## {name}", ""]
    if desc:
        lines.append(desc)
        lines.append("")
    if sig:
        lines.append(f"**Payload:** `{sig}`")
        lines.append("")
    if args:
        lines.append("**Arguments:**")
        for a in args:
            lines.append(f"- {a}")
        lines.append("")
    if payload:
        lines.append("**Payload:**")
        for p in payload:
            lines.append(f"- {p}")
        lines.append("")
    if flags:
        for f in flags:
            lines.append(f"> **Note:** {f}")
        lines.append("")
    return '\n'.join(lines)

def convert_script_page(name, html_text):
    """Convert a script handler page to markdown."""
    if is_stub(html_text):
        return f"## {name}\n\n_No snapshot available._\n"
    content = extract_content_div(html_text)
    if not content or is_empty_node(content):
        return f"## {name}\n\n_No content available._\n"

    desc = extract_api_desc(content)
    sig = extract_signature(content)
    args = extract_section(content, r'Arguments')
    flags = extract_flags(content)

    lines = [f"## {name}", ""]
    if desc:
        lines.append(desc)
        lines.append("")
    if sig:
        lines.append(f"**Signature:** `{sig}`")
        lines.append("")
    if args:
        lines.append("**Arguments:**")
        for a in args:
            lines.append(f"- {a}")
        lines.append("")
    if flags:
        for f in flags:
            lines.append(f"> **Note:** {f}")
        lines.append("")
    return '\n'.join(lines)

def convert_widget_page(name, html_text):
    """Convert a widget page to markdown, including its method sub-pages."""
    is_stub_page = is_stub(html_text)
    content = extract_content_div(html_text) if not is_stub_page else ""
    has_content = content and not is_empty_node(content)

    if is_stub_page:
        lines = [f"## {name}", "", "_No snapshot available for widget overview._", ""]
    elif not has_content:
        lines = [f"## {name}", "", "_No content available._", ""]
    else:
        # Extract widget overview
        m = re.search(r'<div\s+id=["\']widget_overview["\']>(.*?)</div>', content, re.DOTALL)
        overview = strip_tags(m.group(1)) if m else ""

        # Also extract any non-method, non-script content as overview fallback
        if not overview:
            m2 = re.search(r'<div\s+class=["\']api-desc["\']>(.*?)</div>', content, re.DOTALL)
            if m2:
                overview = strip_tags(m2.group(1))

        methods = extract_widget_methods(content)
        script_handlers = extract_widget_scripts(content)

        lines = [f"## {name}", ""]
        if overview:
            lines.append(overview)
            lines.append("")

    # Include method pages if they exist as sub-pages (even if overview is a stub)
    method_dir = DOCS / "widgets" / name
    if method_dir.is_dir():
        method_pages = sorted(method_dir.glob("*.html"))
        real_methods = []
        for mp in method_pages:
            method_name = mp.stem
            method_html = mp.read_text(encoding='utf-8', errors='replace')
            if is_stub(method_html):
                continue
            mcontent = extract_content_div(method_html)
            if not mcontent or is_empty_node(mcontent):
                continue
            mdesc = extract_api_desc(mcontent)
            msig = extract_signature(mcontent)
            margs = extract_section(mcontent, r'Arguments')
            mreturns = extract_section(mcontent, r'Returns')
            mflags = extract_flags(mcontent)

            mlines = [f"### {name}:{method_name}", ""]
            if mdesc:
                mlines.append(mdesc)
                mlines.append("")
            if msig:
                mlines.append(f"**Signature:** `{msig}`")
                mlines.append("")
            if margs:
                mlines.append("**Arguments:**")
                for a in margs:
                    mlines.append(f"- {a}")
                mlines.append("")
            if mreturns:
                mlines.append("**Returns:**")
                for r in mreturns:
                    mlines.append(f"- {r}")
                mlines.append("")
            if mflags:
                for f in mflags:
                    mlines.append(f"> **Note:** {f}")
                mlines.append("")
            real_methods.append('\n'.join(mlines))

        if real_methods:
            lines.append("### Methods")
            lines.append("")
            for rm in real_methods:
                lines.append(rm)

    # Extract script handlers from the overview content (if available)
    if has_content:
        script_handlers = extract_widget_scripts(content)
        if script_handlers:
            lines.append("### Script Handlers")
            lines.append("")
            for s in script_handlers:
                lines.append(f"- {s}")
            lines.append("")

    return '\n'.join(lines)

def main():
    OUT.mkdir(parents=True, exist_ok=True)

    stats = {}

    # === API functions ===
    print("Converting API functions...")
    api_dir = DOCS / "api"
    entries = []
    for f in sorted(api_dir.glob("*.html")):
        name = f.stem
        html_text = f.read_text(encoding='utf-8', errors='replace')
        entry = convert_api_page(name, html_text)
        entries.append(entry)
    api_out = "# WoW API Functions Reference\n\n"
    api_out += f"_{len(entries)} functions total_\n\n---\n\n"
    api_out += '\n'.join(entries)
    (OUT / "api.md").write_text(api_out, encoding='utf-8')
    real = sum(1 for e in entries if 'No snapshot' not in e and 'No content' not in e)
    stats['api'] = (real, len(entries) - real)
    print(f"  {real} real, {len(entries) - real} stubs/empty")

    # === Events ===
    print("Converting events...")
    events_dir = DOCS / "events"
    entries = []
    for f in sorted(events_dir.glob("*.html")):
        name = f.stem
        html_text = f.read_text(encoding='utf-8', errors='replace')
        entry = convert_event_page(name, html_text)
        entries.append(entry)
    events_out = "# WoW API Events Reference\n\n"
    events_out += f"_{len(entries)} events total_\n\n---\n\n"
    events_out += '\n'.join(entries)
    (OUT / "events.md").write_text(events_out, encoding='utf-8')
    real = sum(1 for e in entries if 'No snapshot' not in e and 'No content' not in e)
    stats['events'] = (real, len(entries) - real)
    print(f"  {real} real, {len(entries) - real} stubs/empty")

    # === Widgets ===
    print("Converting widgets...")
    widgets_dir = DOCS / "widgets"
    entries = []
    for f in sorted(widgets_dir.glob("*.html")):
        name = f.stem
        html_text = f.read_text(encoding='utf-8', errors='replace')
        entry = convert_widget_page(name, html_text)
        entries.append(entry)
    widgets_out = "# WoW API Widgets Reference\n\n"
    widgets_out += f"_{len(entries)} widget types total_\n\n---\n\n"
    widgets_out += '\n'.join(entries)
    (OUT / "widgets.md").write_text(widgets_out, encoding='utf-8')
    real = sum(1 for e in entries if 'No snapshot' not in e and 'No content' not in e)
    stats['widgets'] = (real, len(entries) - real)
    print(f"  {real} real, {len(entries) - real} stubs/empty")

    # === Scripts ===
    print("Converting script handlers...")
    scripts_dir = DOCS / "scripts"
    entries = []
    for f in sorted(scripts_dir.glob("*.html")):
        name = f.stem
        html_text = f.read_text(encoding='utf-8', errors='replace')
        entry = convert_script_page(name, html_text)
        entries.append(entry)
    scripts_out = "# WoW API Script Handlers Reference\n\n"
    scripts_out += f"_{len(entries)} script handlers total_\n\n---\n\n"
    scripts_out += '\n'.join(entries)
    (OUT / "scripts.md").write_text(scripts_out, encoding='utf-8')
    real = sum(1 for e in entries if 'No snapshot' not in e and 'No content' not in e)
    stats['scripts'] = (real, len(entries) - real)
    print(f"  {real} real, {len(entries) - real} stubs/empty")

    # === Index ===
    print("Writing index...")
    index = "# WoW API Reference Index\n\n"
    index += "Source: wowprogramming.com (Wayback Machine snapshot, 2010-07-26)\n"
    index += "Target: WoW 3.x / 3.3.5a API\n\n"
    index += "## Files\n\n"
    index += "| File | Real entries | Stubs/Empty | Total |\n"
    index += "|------|-------------|-------------|-------|\n"
    total_real = 0
    total_stub = 0
    for name, (real, stub) in stats.items():
        index += f"| [{name}.md]({name}.md) | {real} | {stub} | {real + stub} |\n"
        total_real += real
        total_stub += stub
    index += f"| **Total** | **{total_real}** | **{total_stub}** | **{total_real + total_stub}** |\n\n"
    index += "## Usage for AI Agents\n\n"
    index += "Each markdown file contains entries separated by `## ` headers.\n"
    index += "Each entry has:\n"
    index += "- Description\n"
    index += "- Signature (function prototype)\n"
    index += "- Arguments (with types in backticks)\n"
    index += "- Returns (with types)\n"
    index += "- Notes (in blockquotes)\n"
    index += "- See also links\n\n"
    index += "Widget entries additionally include method sub-entries (`### Widget:Method`) and script handler lists.\n"
    (OUT / "index.md").write_text(index, encoding='utf-8')

    print("\n=== Done ===")
    print(f"Output: {OUT}/")
    for f in sorted(OUT.glob("*.md")):
        size = f.stat().st_size
        print(f"  {f.name}: {size:,} bytes")

if __name__ == "__main__":
    main()