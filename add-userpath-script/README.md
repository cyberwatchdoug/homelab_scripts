# Add-UserPath Script

## Overview

The `Add-UserPath` PowerShell script provides a reliable way to add a specified directory to the user's PATH environment variable. It ensures the directory exists (creating it if necessary), updates the PATH if the directory is not already present, and refreshes the PATH in the current session so changes take effect immediately.

## Features

- Adds a directory to the user's PATH if not already present.
- Creates the directory if it does not exist.
- Updates the PATH for both new processes and the current session.
- Returns the updated PATH string.
- Reports actions and errors to the console.

## Usage

### Import the Script

```powershell
. .\Add-UserPath.ps1
```

### Add a Custom Directory to PATH

```powershell
Add-UserPath -NewPath "C:\Tools\MyApp\bin"
```

### Add the Default Directory

If you do not specify `-NewPath`, the script uses a default path of `..\..\bin` relative to the script location:

```powershell
Add-UserPath
```

## Parameters

- **-NewPath** (string, optional): The directory to add to the user's PATH. Defaults to `..\..\bin` relative to the script location.

## Notes

- Requires appropriate permissions to modify the user's environment variables.
- The function will create the specified directory if it does not exist.
- The updated PATH will be available to new processes and is also refreshed in the current session.
- The function returns the updated PATH string.

## Example Output

```
The specified path does not exist. Creating it now...
Created new directory: C:\Tools\MyApp\bin
User Path updated successfully.
```

## License

This project is licensed under the GNU General Public License v3. See the [LICENSE](../LICENSE) file for more information.
