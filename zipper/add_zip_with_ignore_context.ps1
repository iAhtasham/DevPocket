# Path to the zip script (defaults to the copy sitting next to this installer)
$scriptPath = Join-Path $PSScriptRoot "zip_with_ignore.ps1"

# Registry path for folders
$regPath = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ZipWithIgnore"

# Create main key
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name "MUIVerb" -Value "Zip with Ignore"
Set-ItemProperty -Path $regPath -Name "Icon" -Value "powershell.exe"

# Create command subkey
$commandPath = "$regPath\command"
New-Item -Path $commandPath -Force | Out-Null

# Command: Run PowerShell with visible console and keep it open
$command = "powershell.exe -NoExit -ExecutionPolicy Bypass -File `"$scriptPath`" `"%V`""
Set-ItemProperty -Path $commandPath -Name "(Default)" -Value $command

Write-Host "✅ 'Zip with Ignore' added to right-click menu for folders."
Write-Host "You may need to restart File Explorer for changes to show."
