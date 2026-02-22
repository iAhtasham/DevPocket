param(
    [string]$TargetDir
)

# --- Initial Validation and Setup ---
if (-not (Test-Path $TargetDir)) {
    Write-Host "ERROR: Target directory not found: $TargetDir"
    Pause
    exit 1
}

$tempDir = Join-Path (Get-Item $TargetDir).Parent.FullName "temp_zip_$(Get-Random)"
$ParentDir = Split-Path $TargetDir
$FolderName = Split-Path $TargetDir -Leaf
$OutputZip = Join-Path $ParentDir "$FolderName.zip"

# Default ignores
$Ignores = @("node_modules", "bin")

# Read from .ignore file if present
$IgnoreFile = Join-Path $TargetDir ".ignore"
if (Test-Path $IgnoreFile) {
    $extraIgnores = Get-Content $IgnoreFile | Where-Object { $_ -and ($_ -notmatch '^#') }
    $Ignores += $extraIgnores
}

Write-Host "Target directory: $TargetDir"
Write-Host "Ignoring: $($Ignores -join ', ')"
Write-Host "Creating temp directory: $tempDir"
Write-Host "Creating ZIP: $OutputZip"

# Create the temporary directory
New-Item -ItemType Directory -Path $tempDir | Out-Null

# --- Recursive Function to Manually Copy Items ---
function Copy-AllowedItems {
    param(
        [string]$sourcePath,
        [string]$destinationPath
    )

    # Get all items in the current directory
    $items = Get-ChildItem -Path $sourcePath -Force

    foreach ($item in $items) {
        # Check if the item's name is in the ignore list
        if ($Ignores -contains $item.Name) {
            Write-Host "🚫 IGNORED: $($item.FullName)" -ForegroundColor Red
            continue
        }

        # Handle directory
        if ($item.PSIsContainer) {
            $newDestination = Join-Path $destinationPath $item.Name
            Write-Host "✅ ALLOWED DIRECTORY: $($item.FullName)" -ForegroundColor Green

            # Create the directory in the temp location
            New-Item -ItemType Directory -Path $newDestination | Out-Null

            # Recursively call this function for the new directory
            Copy-AllowedItems -sourcePath $item.FullName -destinationPath $newDestination
        }
        # Handle file
        else {
            Write-Host "✅ ALLOWED FILE: $($item.FullName)" -ForegroundColor Green
            # Copy the file
            Copy-Item -Path $item.FullName -Destination $destinationPath -Force
        }
    }
}

# --- Main Logic: Start the manual copying process ---
Write-Host "`nStarting manual copy process..."
Copy-AllowedItems -sourcePath $TargetDir -destinationPath $tempDir

# --- Compression and Cleanup ---
Write-Host "`nCompressing temporary directory to ZIP..."
if (Test-Path $OutputZip) {
    Remove-Item $OutputZip -Force
}

Compress-Archive -Path "$tempDir\*" -DestinationPath $OutputZip -Force

Write-Host "Deleting temporary directory..."
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "Done! Created: $OutputZip"

# --- Close the terminal ---
Write-Host "Closing terminal..."
Start-Sleep -Seconds 3 # Give a few seconds to see the final message
exit