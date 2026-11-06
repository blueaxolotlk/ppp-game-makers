# awk state machine: balance braces/parens/brackets in inline JS of site-splitter.html
BEGIN { depth = 0; parens = 0; brackets = 0; ins = 0; inline = 0; blockc = 0; injs = 0 }
/^[[:space:]]*<script>\?/ { }
injs && /^[[:space:]]*<\/script>\?/ { }
{ print }
