# Archive Docs Script

## Overview
The Archive Docs Script is a PowerShell script designed to organize files by moving them into directories based on the year extracted from their filenames. This project includes logging functionality to track actions taken during execution, making it easier to monitor and troubleshoot.

## Features
- Moves files into directories named after the year extracted from the filenames.
- Creates directories if they do not already exist.
- Logs actions and errors to facilitate tracking and debugging.
- Structured for future enhancements and additional features.

## Prerequisites
- PowerShell Core installed on your system.
- Access to the directory containing the files you wish to organize.

## Getting Started

### Running the Script
1. Open PowerShell Core.
2. Navigate to the directory where the `archive_docs.ps1` script is located:
   ```powershell
   cd path\to\archive-docs-script\src
   ```
3. Execute the script:
   ```powershell
   .\archive_docs.ps1
   ```

### Configuring Logging
The script generates log files in the `logs` directory. Ensure that this directory exists before running the script. You can customize the logging behavior within the script as needed.

### Setting Up as a Scheduled Task
To run the script automatically at specified intervals:
1. Open Task Scheduler.
2. Create a new task and set the trigger according to your needs (e.g., daily, weekly).
3. In the "Action" tab, set the action to start a program and enter the following:
   - Program/script: `pwsh`
   - Add arguments: `-File "path\to\archive-docs-script\src\archive_docs.ps1"`
4. Save the task.

## Usage Example
To see how the script processes files, you can run it in a test environment with sample files named in the format `YYYY_filename.ext`. The script will create directories named `YYYY` and move the corresponding files into those directories.

## Logging
Logs will be stored in the `logs` directory. Each execution will create a new log file with a timestamp, allowing you to review past executions and any issues that may have arisen.

## Future Enhancements
- Support for additional file types.
- Options for custom directory structures.
- Enhanced error handling and reporting.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.