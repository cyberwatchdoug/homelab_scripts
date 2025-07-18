# New-SymLink Script

## Overview

The `New-SymLink` PowerShell script automates the process of creating symbolic links for `.ps1` files found in `src` subfolders up to two levels above the script's location. It ensures a specified link folder (default: `bin` in the script root) exists, creates it if necessary, and then links all discovered scripts into that folder.

## Features

- Recursively searches for `.ps1` files in all `src` directories up to two levels above the script location.
- Creates the link folder if it does not exist.
- Creates or replaces symbolic links for each `.ps1` file in the link folder.
- Returns a list of all scripts linked.
- Uses robust error handling with try/catch blocks for all major operations.

## Usage

1. Open a PowerShell session.
2. Run the script or dot-source it to load the function:
   ```powershell
   .\New-SymLink.ps1
   ```
3. Call the function:
   ```powershell
   New-SymLink
   ```
   Or specify a custom link folder:
   ```powershell
   New-SymLink -LinkFolder "custom-bin"
   ```

## Parameters

- `-LinkFolder` (string, optional): The folder where symbolic links will be created. Defaults to `bin` in the script root.

## Return Value

Returns an array of the full paths to the symbolic links created in the link folder.

## Examples

Create links in the default `bin` folder:
```powershell
New-SymLink
```

Create links in a custom folder:
```powershell
New-SymLink -LinkFolder "custom-bin"
```

## Error Handling

- If the script encounters errors while searching for files or creating directories/links, it will write an error message to the console and continue processing remaining items where possible.

## License

This project is licensed under the GNU General Public License v3. See the [LICENSE](../LICENSE) file for more information.