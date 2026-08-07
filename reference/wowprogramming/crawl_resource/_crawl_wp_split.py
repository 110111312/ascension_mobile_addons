#!/usr/bin/env python3
"""
Split the large markdown reference files into smaller, per-category files
that an AI agent can load individually.

Output structure:
  reference/wowprogramming/markdown/
    api/a.md ... api/z.md          (per-letter, ~35KB each)
    widgets/Button.md ... etc.     (per-widget-type, ~10KB each)
    events.md                      (kept as-is, 155KB is manageable)
    scripts.md                     (kept as-is, 28KB)
    api-quick-ref.txt              (kept as-is for discovery)
    events-quick-ref.txt           (kept as-is)
    widgets-quick-ref.txt          (kept as-is)
    scripts-quick-ref.txt          (kept as-is)
    index.md                       (updated with new structure)
"""

import re
from pathlib import Path

OUT = Path("reference/wowprogramming/markdown")

def split_api():
    """Split api.md into per-letter files."""
    text = (OUT / "api.md").read_text(encoding="utf-8")
    api_dir = OUT / "api"
    api_dir.mkdir(exist_ok=True)

    # Split into entries by ## headers
    entries = re.split(r'(?=^## )', text, flags=re.MULTILINE)
    # First chunk is the header
    header = entries[0]

    by_letter = {}
    for entry in entries[1:]:
        m = re.match(r'^## (.+)$', entry, re.MULTILINE)
        if not m:
            continue
        name = m.group(1).strip()
        letter = name[0].upper() if name else '_'
        if not letter.isalpha():
            letter = '_'
        by_letter.setdefault(letter, []).append(entry)

    total = 0
    for letter, entries in sorted(by_letter.items()):
        count = len(entries)
        total += count
        content = f"# WoW API Functions — {letter}\n\n_{count} functions_\n\n---\n\n"
        content += '\n'.join(entries)
        (api_dir / f"{letter.lower()}.md").write_text(content, encoding="utf-8")
        print(f"  api/{letter.lower()}.md: {count} entries, {len(content):,} bytes")

    print(f"  Total: {total} entries across {len(by_letter)} files")

def split_widgets():
    """Split widgets.md into per-widget-type files."""
    text = (OUT / "widgets.md").read_text(encoding="utf-8")
    widgets_dir = OUT / "widgets"
    widgets_dir.mkdir(exist_ok=True)

    # Split into entries by ## headers
    entries = re.split(r'(?=^## )', text, flags=re.MULTILINE)
    header = entries[0]

    total = 0
    for entry in entries[1:]:
        m = re.match(r'^## (.+)$', entry, re.MULTILINE)
        if not m:
            continue
        name = m.group(1).strip()
        # Sanitize filename
        safe_name = re.sub(r'[^a-zA-Z0-9_]', '', name)
        if not safe_name:
            continue
        content = f"# Widget: {name}\n\n---\n\n"
        content += entry
        (widgets_dir / f"{safe_name}.md").write_text(content, encoding="utf-8")
        total += 1
        method_count = entry.count('\n### ')
        print(f"  widgets/{safe_name}.md: {len(content):,} bytes, {method_count} methods")

    print(f"  Total: {total} widget types")

def write_index():
    """Write updated index.md with the new split structure."""
    api_dir = OUT / "api"
    widgets_dir = OUT / "widgets"

    # Gather file info
    api_files = sorted(api_dir.glob("*.md"))
    widget_files = sorted(widgets_dir.glob("*.md"))

    index = "# WoW API Reference Index\n\n"
    index += "Source: wowprogramming.com (Wayback Machine snapshot, 2010-07-26)\n"
    index += "Target: WoW 3.x / 3.3.5a API\n\n"

    index += "## File Structure\n\n"
    index += "```\n"
    index += "markdown/\n"
    index += "  index.md              This file\n"
    index += "  api/a.md ... api/z.md  API functions split by first letter (~35KB each)\n"
    index += "  widgets/Button.md ...   Widget types split by type (~10KB each)\n"
    index += "  events.md              All events (155KB)\n"
    index += "  scripts.md             All script handlers (28KB)\n"
    index += "  api-quick-ref.txt      One-line index of all API functions\n"
    index += "  events-quick-ref.txt   One-line index of all events\n"
    index += "  widgets-quick-ref.txt  One-line index of all widgets + methods\n"
    index += "  scripts-quick-ref.txt  One-line index of all script handlers\n"
    index += "```\n\n"

    index += "## How to Use\n\n"
    index += "### Quick lookup (discovery)\n"
    index += "Search the `*-quick-ref.txt` files for function/event/widget names.\n"
    index += "Each line: `Name | signature | short description`\n\n"
    index += "### Detailed lookup\n"
    index += "1. **API function**: Load `api/<first-letter>.md` (e.g. `api/u.md` for `UnitHealth`)\n"
    index += "2. **Widget method**: Load `widgets/<WidgetType>.md` (e.g. `widgets/Button.md` for `Button:Click`)\n"
    index += "3. **Event**: Load `events.md` and search for `## EVENT_NAME`\n"
    index += "4. **Script handler**: Load `scripts.md` and search for `## HandlerName`\n\n"

    index += "## API Functions by Letter\n\n"
    index += "| File | Entries | Size |\n"
    index += "|------|---------|------|\n"
    for f in api_files:
        count = f.read_text(encoding='utf-8').count('\n## ')
        size = f.stat().st_size
        index += f"| [api/{f.name}](api/{f.name}) | {count} | {size:,} |\n"

    index += f"\n## Widget Types\n\n"
    index += "| File | Methods | Size |\n"
    index += "|------|---------|------|\n"
    for f in widget_files:
        content = f.read_text(encoding='utf-8')
        methods = content.count('\n### ')
        size = f.stat().st_size
        index += f"| [widgets/{f.name}](widgets/{f.name}) | {methods} | {size:,} |\n"

    index += f"\n## Single-File References\n\n"
    index += "| File | Entries | Size |\n"
    index += "|------|---------|------|\n"
    events_count = (OUT / "events.md").read_text(encoding='utf-8').count('\n## ')
    scripts_count = (OUT / "scripts.md").read_text(encoding='utf-8').count('\n## ')
    index += f"| [events.md](events.md) | {events_count} events | {(OUT / 'events.md').stat().st_size:,} |\n"
    index += f"| [scripts.md](scripts.md) | {scripts_count} handlers | {(OUT / 'scripts.md').stat().st_size:,} |\n"

    index += "\n## Quick Reference Files\n\n"
    index += "| File | Entries | Size |\n"
    index += "|------|---------|------|\n"
    for f in sorted(OUT.glob("*-quick-ref.txt")):
        lines = sum(1 for _ in open(f, encoding='utf-8') if _.strip() and not _.startswith('#'))
        index += f"| [{f.name}]({f.name}) | {lines} | {f.stat().st_size:,} |\n"

    (OUT / "index.md").write_text(index, encoding="utf-8")
    print(f"\n  index.md: {len(index):,} bytes")

def main():
    print("Splitting API by letter...")
    split_api()
    print("\nSplitting widgets by type...")
    split_widgets()
    print("\nWriting index...")
    write_index()
    print("\n=== Done ===")

if __name__ == "__main__":
    main()