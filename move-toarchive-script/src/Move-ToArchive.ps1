<#
.SYNOPSIS
    Moves files to year-based directories based on their names.

.DESCRIPTION
    The Move-ToArchive function scans the current directory for files whose names begin with a 4-digit year.
    It moves each file into a subdirectory named after that year, creating the directory if it does not exist.
    All major actions and errors can be logged to a specified log file using the Write-LogMessage function.

.PARAMETER ArchivePath
    The root directory where year-based subdirectories will be created and files will be moved.

.PARAMETER NoLogging
    If specified, disables logging of actions and errors.

.PARAMETER LogFilePath
    The path to the log file where messages will be written. Default is "..\..\logs/move-toarchive.log" relative to the script location.

.EXAMPLE
    Move-ToArchive -ArchivePath "D:\Documents\Archive"

    Moves files in the current directory to year-based subdirectories under D:\Documents\Archive and logs actions.

.EXAMPLE
    Move-ToArchive -ArchivePath "D:\Documents\Archive" -NoLogging

    Moves files without logging any actions or errors.

.NOTES
    - Requires Write-LogMessage.ps1 to be present at "..\..\write-logmessage-script\src\Write-LogMessage.ps1".
    - Logging is enabled by default unless -NoLogging is specified.
    - Errors during directory creation or file moves are logged if logging is enabled.
#>

function Move-ToArchive {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [string]$ArchivePath,

        [Parameter()]
        [switch]$NoLogging = $false,

        [Parameter()]
        [string]$LogFilePath = "$PSScriptRoot\..\..\logs/move-toarchive.log"
    )

    # Check if NoLogging is set
    if (-not $NoLogging) {
        try {
            . "$PSScriptRoot\..\..\write-logmessage-script\src\Write-LogMessage.ps1"
        } catch {
            Write-Host "Failed to load Write-LogMessage.ps1: $_"
        }
    }

    # Log the start of the operation
    if (-not $NoLogging) { Write-LogMessage -Message "Started Move-ToArchive" -LogFilePath $LogFilePath -CreateLogPath -CreateLogFile }
    
    # Ensure the archive path exists
    try {
        if (-not (Test-Path -Path $ArchivePath)) {
            New-Item -ItemType Directory -Path $ArchivePath | Out-Null
            if (-not $NoLogging) { Write-LogMessage -Message "Created archive directory: $ArchivePath" -LogFilePath $LogFilePath }
        }
    } catch {
        if (-not $NoLogging) { Write-LogMessage -Message "Error creating archive directory: $_" -LogFilePath $LogFilePath -Level ERROR }
        return
    }

    # Get all files in the current directory
    Get-ChildItem -File | ForEach-Object {
        $fileName = $_.Name
        if ($fileName -match '(\d{4})') {
            $year = $matches[1]
            $yearDir = Join-Path -Path $ArchivePath -ChildPath $year

            # Create year directory if it doesn't exist
            try {
                if (-not (Test-Path -Path $yearDir)) {
                    New-Item -ItemType Directory -Path $yearDir | Out-Null
                    if (-not $NoLogging) { Write-LogMessage -Message "Created year directory: $yearDir" -LogFilePath $LogFilePath }
                }

                # Move the file to the year directory
                Move-Item -Path $_.FullName -Destination $yearDir    
            } catch {
                if (-not $NoLogging) { Write-LogMessage -Message "Error creating year directory: $_" -LogFilePath $LogFilePath -Level ERROR }
                return
            }
        }
    }
}