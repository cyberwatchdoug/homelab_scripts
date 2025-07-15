# Write-LogMessage custom power shell script for logging messages
<#
.SYNOPSIS
    Logs messages to a specified log file with timestamps.

.DESCRIPTION
    This script defines a function to log messages with timestamps and log levels to a log file.
    It can optionally create the log directory and/or log file if they do not exist, and can also write messages to the console.

.PARAMETER Message
    The message to log. It should be a string that describes the event or action being logged.

.PARAMETER LogFilePath
    The path to the log file where messages will be written. Default is "logs/write_logmessage.log".

.PARAMETER Level
    The log level for the message. Accepts "INFO", "WARNING", or "ERROR". Default is "INFO".

.PARAMETER WriteToHost
    If specified, also writes the log message to the console.

.PARAMETER CreateLogPath
    If specified, creates the log directory if it does not exist.

.PARAMETER CreateLogFile
    If specified, creates the log file if it does not exist.

.PARAMETER TimestampFormat
    The format string for the timestamp. Default is "yyyy-MM-dd HH:mm:ss".

.EXAMPLE
    Write-LogMessage -Message "This is a log message." -LogFilePath "logs/my_log.log"

.EXAMPLE
    Write-LogMessage -Message "Warning example." -Level WARNING -WriteToHost

.EXAMPLE
    Write-LogMessage -Message "Auto-create log path and file." -CreateLogPath -CreateLogFile

.EXAMPLE
    "First message", "Second message" | Write-LogMessage -LogFilePath "logs/batch.log" -WriteToHost

.LINK
    For more information, visit the documentation at https://cyberwatchdoug github    
#>
function Write-LogMessage {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('Msg')]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$LogFilePath,

        [Parameter()]
        [ValidateSet("INFO", "WARNING", "ERROR")]
        [string]$Level = "INFO",

        [Parameter()]
        [switch]$WriteToHost,

        [Parameter()]
        [switch]$CreateLogPath,   # If set, create the log directory if it doesn't exist

        [Parameter()]
        [switch]$CreateLogFile,    # If set, create the log file if it doesn't exist

        [Parameter()]
        [string]$TimestampFormat = "yyyy-MM-dd HH:mm:ss"
    )
    process {
        if (-not $Message) { return }
        $timestamp = Get-Date -Format $TimestampFormat
        $logDir = Split-Path -Path $LogFilePath -Parent
        $logMessage = "$timestamp [$Level] - $Message"

        # Check if log directory exists
        if (!(Test-Path -Path $logDir)) {
            if ($CreateLogPath) {
                try {
                    New-Item -ItemType Directory -Path $logDir | Out-Null
                } catch {
                    Write-Error "Failed to create log directory: $logDir"
                    if ($WriteToHost) { Write-Host "Failed to create log directory: $logDir" }
                    return
                }
            } else {
                Write-Error "Log directory does not exist: $logDir. Use -CreateLogPath to create it."
                if ($WriteToHost) { Write-Host "Log directory does not exist: $logDir. Use -CreateLogPath to create it." }
                return
            }
        }

        # Check if log file exists
        if (!(Test-Path -Path $LogFilePath)) {
            if ($CreateLogFile) {
                try {
                    New-Item -ItemType File -Path $LogFilePath | Out-Null
                } catch {
                    Write-Error "Failed to create log file: $LogFilePath"
                    if ($WriteToHost) { Write-Host "Failed to create log file: $LogFilePath" }
                    return
                }
            } else {
                Write-Error "Log file does not exist: $LogFilePath. Use -CreateLogFile to create it."
                if ($WriteToHost) { Write-Host "Log file does not exist: $LogFilePath. Use -CreateLogFile to create it." }
                return
            }
        }

        try {
            $logMessage | Out-File -FilePath $LogFilePath -Append -Encoding UTF8
            if ($WriteToHost) {
                Write-Host $logMessage
            }
        } catch {
            Write-Error "Failed to write log message: $_"
            if ($WriteToHost) { Write-Host "Failed to write log message: $_" }
        }
        Write-Output $logMessage
    }
}