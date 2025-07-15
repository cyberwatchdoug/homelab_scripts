# Write-LogMessage.ps1

A reusable PowerShell function for logging messages with timestamps and log levels to a specified log file. Supports automatic creation of log directories and files if desired.

## Features

- Logs messages with timestamp and log level (INFO, WARNING, ERROR)
- Optionally writes log messages to the console
- Can create log directory and/or log file if they do not exist
- Accepts pipeline input for messages
- Customizable timestamp format

## Parameters

- **-Message** (string, required): The message to log.
- **-LogFilePath** (string, optional): Path to the log file. Default is `logs/write_logmessage.log`.
- **-Level** (string, optional): Log level. Accepts `INFO`, `WARNING`, or `ERROR`. Default is `INFO`.
- **-WriteToHost** (switch, optional): Also writes the log message to the console.
- **-CreateLogPath** (switch, optional): Create the log directory if it does not exist.
- **-CreateLogFile** (switch, optional): Create the log file if it does not exist.
- **-TimestampFormat** (string, optional): Format string for the timestamp. Default is `"yyyy-MM-dd HH:mm:ss"`.

## Usage

```powershell
Write-LogMessage -Message "This is a log message." -LogFilePath "logs/my_log.log"
Write-LogMessage -Message "Warning example." -Level WARNING -WriteToHost
Write-LogMessage -Message "Auto-create log path and file." -CreateLogPath -CreateLogFile
Write-LogMessage -Message "Custom timestamp format." -TimestampFormat "MM/dd/yyyy HH:mm:ss"
```

If the log directory or file does not exist and the corresponding `-CreateLogPath` or `-CreateLogFile` switch is not set, the function will display an error and not write the message.

## Example with Pipeline

```powershell
"First message", "Second message" | Write-LogMessage -LogFilePath "logs/batch.log" -WriteToHost
```

## Pester Tests

Automated tests for `Write-LogMessage.ps1` are provided in the `tests\Write-LogMessage.Tests.ps1` file using the [Pester](https://pester.dev/) framework.

### How to Run

Open a PowerShell terminal in the project root and run:

```powershell
Invoke-Pester -Path .\tests\Write-LogMessage.Tests.ps1
```

### What Is Tested

- Logging to a file and verifying output
- Log level formatting
- Console output with `-WriteToHost`
- Return value of the function
- Automatic creation of log directory and file
- Error handling when directory or file does not exist
- Custom timestamp format
- Pipeline input support

### Notes

- The function returns the log message string after writing it.
- Errors encountered during directory or file creation, or writing to the log, are displayed in the console and written to the error log.
- Pester tests help ensure the reliability and correctness of the function.