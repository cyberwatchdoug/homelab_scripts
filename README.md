# homelab_scripts

A collection of PowerShell scripts for automating and organizing tasks in a home lab environment.

## Contents

- [move-toarchive-script](move-toarchive-script/): Organize files into year-based directories with logging support.
- [write-logmessage-script](write-logmessage-script/): Reusable logging function for PowerShell scripts.

---

## Scripts Overview

### [move-toarchive-script](move-toarchive-script/)

Automates the process of sorting files into subdirectories based on the year found in their filenames. Useful for archiving documents, photos, or other files that follow a year-based naming convention. Includes robust logging and error handling, and is suitable for use as a scheduled task.

- Moves files into directories named after the year in the filename.
- Creates archive and year directories as needed.
- Integrates with the logging function from `write-logmessage-script`.
- Logging can be enabled or disabled.
- See [move-toarchive-script/README.md](move-toarchive-script/README.md) for usage and setup details.

### [write-logmessage-script](write-logmessage-script/)

Provides a flexible `Write-LogMessage` function for logging messages to files with timestamps and log levels. Designed to be imported and used by other scripts in this repository.

- Logs messages with customizable timestamp and log level (INFO, WARNING, ERROR).
- Can create log directories and files automatically.
- Supports writing to both log files and the console.
- Accepts pipeline input for batch logging.
- Includes Pester tests for reliability.
- See [write-logmessage-script/README.md](write-logmessage-script/README.md) for full documentation and examples.

---

## Getting Started

1. Clone this repository.
2. Review each script directory for usage instructions and prerequisites.
3. Use the logging script as a building block for your own PowerShell automation.

## License

See [LICENSE](LICENSE) for details.