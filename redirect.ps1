param([string]$targetDir="./publish/redirect/") 

New-Item -Force $targetDir -ItemType "directory"

$template = '<!DOCTYPE HTML>
<html lang="en-US">
    <script type="text/javascript">
        window.location.href = "{0}";
    </script>
    <meta http-equiv="refresh" content="0;url={0}">
    Váš prohlížeč nedpodporuje přesměrování!' +
"<br>   <a href='{0}'>Přejít na cíl.</a> 
</html>"

$dict = @{
    "scenar-2025"="https://docs.google.com/document/d/e/2PACX-1vSx10LW_SeMqRtRyhHYL3zI7LnhgaVgw1a3t6D2EVU4Zh0Iq6LaUlx51YKy4IOVt-E2h04eo-u33QGu/pub";
    "scenar-prosinec"="https://docs.google.com/document/d/e/2PACX-1vTBlvgLLEHblLn8S7HBlSkbWPlGpZmY5PvLSspYdZJLBPxXRNuVhQaFpxDezOsckXuzV5dF-w_-wUoB/pub";
}

foreach ($key in $dict.Keys) {
    $content = $template -f $($dict[$key])
    
    $content | Out-File -FilePath $($targetDir + $key + ".html") -Force
}