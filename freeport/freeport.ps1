param(
    [Alias("f")]
    [Parameter(Mandatory=$true)]
    [int]$Port
)

# Find process using the port
$process = netstat -ano | Select-String ":$Port " | Select-String "LISTENING"

if ($process) {
    $targetPid = ($process -split '\s+')[-1]
    Write-Host "🔍 Port $Port is used by PID $targetPid"
    Write-Host "🚫 Killing PID $targetPid ..."
    taskkill /PID $targetPid /F
    Write-Host "✅ Port $Port is now free."
} else {
    Write-Host "✔ Port $Port is already free."
}
