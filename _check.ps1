$src = Get-Content -Raw 'site-splitter.html'
$blocks = [regex]::Matches($src, '(?s)<script>(.*?)</script>')
Write-Host ("blocks: " + $blocks.Count)
$js = $blocks[$blocks.Count - 1].Groups[1].Value
$jsClean = [regex]::Replace($js, '<\\/script>', '')
Write-Host ("literal close tag in JS: " + ($jsClean -match '</script>'))
$chars = $js.ToCharArray()
$brace = 0; $paren = 0; $brack = 0
$ins = [char]0
for ($i = 0; $i -lt $chars.Count; $i++) {
    $c = $chars[$i]
    if ($ins -ne [char]0) {
        if ($c -eq '\') { $i++; continue }
        if ($c -eq $ins) { $ins = [char]0 }
        continue
    }
    if ($c -eq '"' -or $c -eq "'" -or $c -eq '`') { $ins = $c; continue }
    if ($c -eq '/' -and ($i + 1) -lt $chars.Count -and $chars[$i+1] -eq '/') { $i++; continue }
    if ($c -eq '/' -and ($i + 1) -lt $chars.Count -and $chars[$i+1] -eq '*') { $i++; continue }
    if ($c -eq '{') { $brace++ }
    if ($c -eq '}') { $brace-- }
    if ($c -eq '(') { $paren++ }
    if ($c -eq ')') { $paren-- }
    if ($c -eq '[') { $brack++ }
    if ($c -eq ']') { $brack-- }
}
Write-Host ("unclosed string: " + ($ins -ne [char]0))
Write-Host ("braces: " + $brace + " parens: " + $paren + " brackets: " + $brack)
