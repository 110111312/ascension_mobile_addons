def strip_lua(src):
    out = []
    i, n = 0, len(src)
    in_str = False
    in_comment = False
    line_comment = False
    while i < n:
        c = src[i]
        if line_comment:
            if c == '\n':
                line_comment = False
                out.append(c)
            i += 1
            continue
        if in_comment:
            if c == '[' and i + 1 < n and src[i + 1] == '[':
                end = src.find(']]', i + 2)
                if end == -1:
                    i = n
                    break
                i = end + 2
                in_comment = False
                continue
            if c == ']' and i + 1 < n and src[i + 1] == ']':
                i += 2
                in_comment = False
                continue
            i += 1
            continue
        if in_str:
            out.append(c)
            if c == '\\' and i + 1 < n:
                out.append(src[i + 1])
                i += 2
                continue
            if c == '"':
                in_str = False
            i += 1
            continue
        if c == '"':
            in_str = True
            out.append(c)
            i += 1
            continue
        if c == '-' and i + 1 < n and src[i + 1] == '-':
            if i + 2 < n and src[i + 2] == '[' and i + 3 < n and src[i + 3] == '[':
                in_comment = True
                i += 4
                continue
            line_comment = True
            i += 2
            continue
        out.append(c)
        i += 1
    return ''.join(out)

import sys
for f in sys.argv[1:]:
    src = open(f, encoding='utf-8').read()
    s = strip_lua(src)
    for a, b in [('(', ')'), ('[', ']'), ('{', '}')]:
        print(f, a, s.count(a), b, s.count(b), 'OK' if s.count(a) == s.count(b) else 'MISMATCH')
