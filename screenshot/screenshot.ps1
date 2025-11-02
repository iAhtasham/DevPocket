<#
.SYNOPSIS
    Captures the screen of a connected Android device (via adb) and copies it to the Windows clipboard.
.PARAMETER Save
    Optional path to also keep a copy of the PNG on disk.
.EXAMPLE
    .\screenshot.ps1
    .\screenshot.ps1 -Save C:\Users\me\Desktop\shot.png
#>
[CmdletBinding()]
param([string]$Save)

$devicePath = '/sdcard/__screenshot.png'
$localPath  = Join-Path $env:TEMP ("android-screenshot-{0}.png" -f ([guid]::NewGuid().ToString('N')))

& adb shell screencap -p $devicePath
if ($LASTEXITCODE -ne 0) { Write-Error 'adb screencap failed (device connected / authorized?)'; return }

& adb pull $devicePath $localPath | Out-Null
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $localPath)) { Write-Error 'adb pull failed'; return }
& adb shell rm -f $devicePath | Out-Null

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

$copy = {
    param($path)
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $ms = New-Object System.IO.MemoryStream(,$bytes)
    $img = [System.Drawing.Image]::FromStream($ms)
    try { [System.Windows.Forms.Clipboard]::SetImage($img) }
    finally { $img.Dispose(); $ms.Dispose() }
}

if ([Threading.Thread]::CurrentThread.GetApartmentState() -eq 'STA') {
    & $copy $localPath
} else {
    # Clipboard requires an STA thread (PowerShell 7 / -MTA hosts)
    $ps = [PowerShell]::Create()
    $rs = [RunspaceFactory]::CreateRunspace()
    $rs.ApartmentState = 'STA'
    $rs.Open()
    $ps.Runspace = $rs
    [void]$ps.AddScript($copy.ToString()).AddArgument($localPath)
    $ps.Invoke() | Out-Null
    $ps.Dispose(); $rs.Close()
}

if ($Save) {
    Copy-Item $localPath $Save -Force
    Write-Host "Screenshot copied to clipboard and saved to $Save" -ForegroundColor Green
} else {
    Write-Host 'Screenshot copied to clipboard.' -ForegroundColor Green
}

Remove-Item $localPath -Force -ErrorAction SilentlyContinue
