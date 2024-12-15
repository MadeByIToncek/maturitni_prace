$val = "maturitni_prace.tex"
echo "Counting character counts for $val"

$chars = perl ./texcount.pl -char -brief $val
$words = perl ./texcount.pl -brief $val

$sep = "\+"

$charsplit = $chars -split $sep
$charsintext = [int]$charsplit[0]
$charsintitles = [int]$charsplit[1]
$charsincaptions = [int](($charsplit[2]) -split " ")[0]

$wordsplit = $words -split $sep
$wordsintext = [int]$wordsplit[0]
$wordsintitles = [int]$wordsplit[1]
$wordsincaptions = [int](($wordsplit[2]) -split " ")[0]

""
"Characters in text (normpages)"
$charsum = $charsintext + $wordsintext
$charsum.ToString() + " (" + ($charsum/1800).ToString() + ") " + "[" + (($charsum/(20*1800))*100) + "%]"

""
"Characters in titles"
$titlesum = $charsintitles + $wordsintitles
$titlesum.ToString() + " (" + ($titlesum/1800).ToString() + ") " + "[" + (($titlesum/(20*1800))*100) + "%]"

""
"Characters in captions"
$captionsum = $charsincaptions + $wordsincaptions
$captionsum.ToString() + " (" + ($captionsum/1800).ToString() + ") " + "[" + (($captionsum/(20*1800))*100) + "%]"

""
"Total"
$grand_total = $charsum + $titlesum + $captionsum
$grand_total.ToString() + " (" + ($grand_total/1800).ToString() + ") " + "[" + (($grand_total/(20*1800))*100) + "%]"