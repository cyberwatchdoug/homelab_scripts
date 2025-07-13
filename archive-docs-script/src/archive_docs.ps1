# PowerShell script for archiving documents with logging and room for future enhancements

# Define the log file path
$logFilePath = "logs/archive_docs.log"

# Function to log messages
function Write-LogMessage {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFilePath -Append -Encoding UTF8
}

# Start logging
Write-LogMessage "Script execution started."

# Get the current directory
$currentDir = Get-Location

# Process files
try {
    Get-ChildItem -File | Where-Object { $_.Name -match '^(\d{4})' } | ForEach-Object {
        $year = $matches[1]
        if (!(Test-Path $year)) {
            New-Item -ItemType Directory -Name $year | Out-Null
            Write-LogMessage "Created directory: $currentDir\$year"
        }
        Move-Item $_.FullName -Destination $year
        Write-LogMessage "Moved file: $($_.Name) to directory: $currentDir\$year"
    }
} catch {
    Write-LogMessage "Error occurred: $_"
}

# End logging
Write-LogMessage "Script execution completed."