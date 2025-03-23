param([string]$targetFile="") 

$val = "maturitni_prace.tex"
"Counting character counts for $val"

$chars = perl ./texcount.pl -char -sub=part $val
$words = perl ./texcount.pl -sub=part $val

$sep = "\n"
$sep2 = "\+"

$totalchars = 0;

$loop = 12..13;

$a = @()

foreach ($i in $loop) {
    $cs = $chars -split $sep
    $charsplit = $cs[[int]$i] -split $sep2
    $charsintext = [int]$charsplit[0]

    $ws = $words -split $sep
    $wordsplit = $ws[[int]$i] -split $sep2
    $wordsintext = [int]$wordsplit[0]

    $charsum = $charsintext + $wordsintext

    $charnp = ($charsum/1800)


    $part = "";
    $reqs = 0;

    if ([int]$i -eq 13) {
        $part = "Praktická část"
        $reqs = 5;
    } else {
        $part = "Teoretická část"
        $reqs = 15;
    }
    
    $charp = (($charsum) / (1800*$reqs))

    $totalchars += $charsum;
    
    $a += [pscustomobject]@{PartName = $part; CharsInText = $charsum; NormPagesFinished = "{0:f2}" -f $charnp; PercentFinished = "{0:p}" -f $charp}
}

$a += [pscustomobject]@{PartName = "<total>"; CharsInText = $totalchars; NormPagesFinished = "{0:f2}" -f ($totalchars/1800); PercentFinished = "{0:p}" -f (($totalchars) / (1800*20))}

$v = $a | Format-Table -AutoSize
$OutputEncoding = [Text.Encoding]::ASCII

if($targetFile -eq "") {
    $v
} else {
    
    $v | Out-File -FilePath $targetFile -Force
}