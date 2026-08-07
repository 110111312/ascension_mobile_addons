# WoW API Reference Index

Source: wowprogramming.com (Wayback Machine snapshot, 2010-07-26)
Target: WoW 3.x / 3.3.5a API

## File Structure

```
markdown/
  index.md                       This file
  api/<letter>.md                API functions by first letter
  api/g-get-<letter>.md           Get* functions split by next letter
  api/c-<letter>.md               C* functions split by second letter
  api/s-<letter>.md               S* functions split by second letter
  widgets/<WidgetType>.md         One file per widget type (with methods)
  events/<letter>.md              Events by first letter
  scripts.md                      All script handlers (28KB)
  api-quick-ref.txt               One-line index of all API functions
  events-quick-ref.txt            One-line index of all events
  widgets-quick-ref.txt           One-line index of all widgets + methods
  scripts-quick-ref.txt           One-line index of all script handlers
```

## How to Use

### Quick lookup (discovery)
Search the `*-quick-ref.txt` files for function/event/widget names.
Each line: `Name | signature | short description`

### Detailed lookup
1. **API function** `UnitHealth` → load `api/u.md`
2. **API function** `GetTime` → load `api/g-get-t.md`
3. **API function** `CreateFrame` → load `api/c-a.md`
4. **API function** `SetMinimap` → load `api/s-e.md`
5. **Widget method** `Button:Click` → load `widgets/Button.md`
6. **Event** `CHAT_MSG_SAY` → load `events/c.md`
7. **Script handler** `OnLoad` → load `scripts.md`

## API Function Files

| File | Entries | Size |
|------|---------|------|
| [api/a.md](api/a.md) | 47 | 15,176 |
| [api/b.md](api/b.md) | 73 | 16,548 |
| [api/c-a.md](api/c-a.md) | 157 | 80,384 |
| [api/c-e.md](api/c-e.md) | 1 | 392 |
| [api/c-h.md](api/c-h.md) | 26 | 12,062 |
| [api/c-l.md](api/c-l.md) | 42 | 14,326 |
| [api/c-o.md](api/c-o.md) | 72 | 18,130 |
| [api/c-r.md](api/c-r.md) | 5 | 2,029 |
| [api/c-u.md](api/c-u.md) | 5 | 1,829 |
| [api/d.md](api/d.md) | 50 | 15,309 |
| [api/e.md](api/e.md) | 28 | 12,671 |
| [api/f.md](api/f.md) | 17 | 5,881 |
| [api/g-get-a.md](api/g-get-a.md) | 55 | 40,853 |
| [api/g-get-b.md](api/g-get-b.md) | 37 | 23,255 |
| [api/g-get-c.md](api/g-get-c.md) | 65 | 37,799 |
| [api/g-get-d.md](api/g-get-d.md) | 8 | 2,155 |
| [api/g-get-e.md](api/g-get-e.md) | 13 | 4,763 |
| [api/g-get-f.md](api/g-get-f.md) | 11 | 8,884 |
| [api/g-get-g.md](api/g-get-g.md) | 35 | 21,313 |
| [api/g-get-h.md](api/g-get-h.md) | 3 | 1,497 |
| [api/g-get-i.md](api/g-get-i.md) | 37 | 31,730 |
| [api/g-get-k.md](api/g-get-k.md) | 1 | 438 |
| [api/g-get-l.md](api/g-get-l.md) | 46 | 11,982 |
| [api/g-get-m.md](api/g-get-m.md) | 42 | 21,836 |
| [api/g-get-n.md](api/g-get-n.md) | 91 | 33,820 |
| [api/g-get-o.md](api/g-get-o.md) | 3 | 1,398 |
| [api/g-get-p.md](api/g-get-p.md) | 38 | 17,023 |
| [api/g-get-q.md](api/g-get-q.md) | 43 | 20,578 |
| [api/g-get-r.md](api/g-get-r.md) | 31 | 15,589 |
| [api/g-get-s.md](api/g-get-s.md) | 53 | 28,225 |
| [api/g-get-t.md](api/g-get-t.md) | 64 | 34,292 |
| [api/g-get-u.md](api/g-get-u.md) | 9 | 5,136 |
| [api/g-get-v.md](api/g-get-v.md) | 7 | 3,156 |
| [api/g-get-w.md](api/g-get-w.md) | 7 | 6,134 |
| [api/g-get-x.md](api/g-get-x.md) | 1 | 406 |
| [api/g-get-z.md](api/g-get-z.md) | 2 | 1,417 |
| [api/g-other.md](api/g-other.md) | 37 | 12,536 |
| [api/h.md](api/h.md) | 16 | 5,475 |
| [api/i.md](api/i.md) | 140 | 57,591 |
| [api/j.md](api/j.md) | 6 | 1,835 |
| [api/k.md](api/k.md) | 24 | 9,908 |
| [api/l.md](api/l.md) | 21 | 9,294 |
| [api/m.md](api/m.md) | 47 | 15,754 |
| [api/n.md](api/n.md) | 8 | 4,041 |
| [api/o.md](api/o.md) | 5 | 1,217 |
| [api/p.md](api/p.md) | 58 | 23,771 |
| [api/q.md](api/q.md) | 19 | 6,593 |
| [api/r.md](api/r.md) | 65 | 19,569 |
| [api/s-a.md](api/s-a.md) | 3 | 1,524 |
| [api/s-c.md](api/s-c.md) | 2 | 1,221 |
| [api/s-e.md](api/s-e.md) | 155 | 70,143 |
| [api/s-h.md](api/s-h.md) | 13 | 5,042 |
| [api/s-i.md](api/s-i.md) | 3 | 519 |
| [api/s-o.md](api/s-o.md) | 22 | 10,602 |
| [api/s-p.md](api/s-p.md) | 11 | 5,311 |
| [api/s-q.md](api/s-q.md) | 1 | 338 |
| [api/s-t.md](api/s-t.md) | 37 | 12,148 |
| [api/s-u.md](api/s-u.md) | 2 | 775 |
| [api/s-w.md](api/s-w.md) | 1 | 643 |
| [api/t.md](api/t.md) | 61 | 20,029 |
| [api/u.md](api/u.md) | 118 | 64,502 |
| [api/v.md](api/v.md) | 36 | 8,364 |
| [api/w.md](api/w.md) | 2 | 855 |
| [api/x.md](api/x.md) | 1 | 621 |
| [api/z.md](api/z.md) | 1 | 366 |
| **Total** | **2140** | |

## Widget Type Files

| File | Methods | Size |
|------|---------|------|
| [widgets/Alpha.md](widgets/Alpha.md) | 4 | 2,064 |
| [widgets/Animation.md](widgets/Animation.md) | 27 | 10,376 |
| [widgets/AnimationGroup.md](widgets/AnimationGroup.md) | 19 | 7,404 |
| [widgets/Button.md](widgets/Button.md) | 35 | 11,812 |
| [widgets/CheckButton.md](widgets/CheckButton.md) | 7 | 1,837 |
| [widgets/ColorSelect.md](widgets/ColorSelect.md) | 13 | 5,952 |
| [widgets/ControlPoint.md](widgets/ControlPoint.md) | 6 | 2,337 |
| [widgets/Cooldown.md](widgets/Cooldown.md) | 7 | 3,542 |
| [widgets/DressUpModel.md](widgets/DressUpModel.md) | 6 | 3,058 |
| [widgets/EditBox.md](widgets/EditBox.md) | 49 | 18,337 |
| [widgets/Font.md](widgets/Font.md) | 6 | 1,570 |
| [widgets/FontInstance.md](widgets/FontInstance.md) | 17 | 7,509 |
| [widgets/FontString.md](widgets/FontString.md) | 12 | 4,359 |
| [widgets/Frame.md](widgets/Frame.md) | 88 | 30,802 |
| [widgets/GameTooltip.md](widgets/GameTooltip.md) | 69 | 32,034 |
| [widgets/LayeredRegion.md](widgets/LayeredRegion.md) | 4 | 2,057 |
| [widgets/MessageFrame.md](widgets/MessageFrame.md) | 14 | 8,464 |
| [widgets/Minimap.md](widgets/Minimap.md) | 17 | 8,504 |
| [widgets/Model.md](widgets/Model.md) | 26 | 13,200 |
| [widgets/MovieFrame.md](widgets/MovieFrame.md) | 5 | 3,731 |
| [widgets/ParentedObject.md](widgets/ParentedObject.md) | 2 | 615 |
| [widgets/Path.md](widgets/Path.md) | 6 | 1,733 |
| [widgets/PlayerModel.md](widgets/PlayerModel.md) | 11 | 2,767 |
| [widgets/QuestPOIFrame.md](widgets/QuestPOIFrame.md) | 15 | 1,971 |
| [widgets/Region.md](widgets/Region.md) | 27 | 9,583 |
| [widgets/Rotation.md](widgets/Rotation.md) | 8 | 3,453 |
| [widgets/Scale.md](widgets/Scale.md) | 6 | 2,842 |
| [widgets/ScriptObject.md](widgets/ScriptObject.md) | 5 | 2,329 |
| [widgets/ScrollFrame.md](widgets/ScrollFrame.md) | 11 | 7,002 |
| [widgets/ScrollingMessageFrame.md](widgets/ScrollingMessageFrame.md) | 34 | 13,393 |
| [widgets/SimpleHTML.md](widgets/SimpleHTML.md) | 24 | 14,606 |
| [widgets/Slider.md](widgets/Slider.md) | 15 | 7,312 |
| [widgets/StatusBar.md](widgets/StatusBar.md) | 13 | 4,975 |
| [widgets/TabardModel.md](widgets/TabardModel.md) | 12 | 5,753 |
| [widgets/Texture.md](widgets/Texture.md) | 18 | 10,900 |
| [widgets/Translation.md](widgets/Translation.md) | 4 | 1,759 |
| [widgets/UIObject.md](widgets/UIObject.md) | 4 | 1,049 |
| [widgets/VisibleRegion.md](widgets/VisibleRegion.md) | 7 | 2,065 |
| **Total** | **38 types, 653 methods** | |

## Event Files

| File | Entries | Size |
|------|---------|------|
| [events/a.md](events/a.md) | 31 | 6,163 |
| [events/b.md](events/b.md) | 57 | 6,038 |
| [events/c.md](events/c.md) | 111 | 59,572 |
| [events/d.md](events/d.md) | 9 | 1,411 |
| [events/e.md](events/e.md) | 10 | 2,550 |
| [events/f.md](events/f.md) | 1 | 172 |
| [events/g.md](events/g.md) | 31 | 5,382 |
| [events/h.md](events/h.md) | 1 | 99 |
| [events/i.md](events/i.md) | 18 | 4,795 |
| [events/k.md](events/k.md) | 10 | 1,292 |
| [events/l.md](events/l.md) | 27 | 3,701 |
| [events/m.md](events/m.md) | 26 | 5,120 |
| [events/n.md](events/n.md) | 3 | 486 |
| [events/o.md](events/o.md) | 3 | 404 |
| [events/p.md](events/p.md) | 79 | 13,870 |
| [events/q.md](events/q.md) | 12 | 6,153 |
| [events/r.md](events/r.md) | 12 | 2,407 |
| [events/s.md](events/s.md) | 16 | 2,970 |
| [events/t.md](events/t.md) | 27 | 4,688 |
| [events/u.md](events/u.md) | 93 | 24,179 |
| [events/v.md](events/v.md) | 19 | 2,866 |
| [events/w.md](events/w.md) | 6 | 1,761 |
| [events/z.md](events/z.md) | 3 | 617 |
| **Total** | **605** | |

## Single-File References

| File | Entries | Size |
|------|---------|------|
| [scripts.md](scripts.md) | 65 handlers | 27,748 |

## Quick Reference Files (for discovery)

| File | Lines | Size |
|------|-------|------|
| [api-quick-ref.txt](api-quick-ref.txt) | 1800 | 275,472 |
| [events-quick-ref.txt](events-quick-ref.txt) | 514 | 55,624 |
| [scripts-quick-ref.txt](scripts-quick-ref.txt) | 65 | 9,433 |
| [widgets-quick-ref.txt](widgets-quick-ref.txt) | 691 | 16,236 |
