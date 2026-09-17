$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

Write-Host "DevPocket installed. Available commands: freeport, adbshot, zipper" -ForegroundColor Green
Write-Host "Run any of them with -h / no args to see usage." -ForegroundColor Green
