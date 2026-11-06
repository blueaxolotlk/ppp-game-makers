import re
src = open('site-splitter.html', encoding='utf-8').read()
blocks = re.findall(r'<script>(.*?)</script>', src, re.S)
print("blocks:", len(blocks))
js = blocks[0]
# strip strings, comments, regex-lite: use naive state machine on tokens
out = []
i = 0
n = len(js)
ins = None
while i < n:
    c = js[i]
    nxt = js[i+1] if i+1 < n else ''
    if ins:
        if c == '\\':
            i += 2
            continue
        if c == ins:
            ins = None
            out.append('X')
        i += 1
        continue
    if c in '"\'`':
        ins = c
        i += 1
        continue
    if c == '/' and nxt == '/':
        while i < n and js[i] != '\n':
            i += 1
        continue
    if c == '/' and nxt == '*':
        i = js.find('*/', i)
        i = n if i < 0 else i + 2
        continue
    out.append(c)
    i += 1
clean = ''.join(out)
print('unclosed string:', ins)
print('braces:', clean.count('{') - clean.count('}'))
print('parens:', clean.count('(') - clean.count(')'))
print('brackets:', clean.count('[') - clean.count(']'))
print('literal close-script tag present:', '</scr' + 'ipt>' in clean)
