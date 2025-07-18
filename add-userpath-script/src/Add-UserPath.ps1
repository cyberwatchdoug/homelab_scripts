<#
.SYNOPSIS
    Adds a specified directory to the user's PATH environment variable and refreshes it in the current session.

.DESCRIPTION
    The Add-UserPath function checks if a given directory exists and creates it if necessary.
    It then verifies whether the directory is already present in the user's PATH environment variable.
    If not, it appends the directory to the PATH and updates the environment variable for the current session.
    All actions and errors are reported to the console.
    The function returns the updated PATH value as seen by the current session.

.PARAMETER NewPath
    The directory to add to the user's PATH. Defaults to "..\..\bin" relative to the script location if not specified.

.EXAMPLE
    Add-UserPath -NewPath "C:\Tools\MyApp\bin"
    Adds "C:\Tools\MyApp\bin" to the user's PATH if it is not already present, creates the directory if needed, and refreshes the session PATH.

.EXAMPLE
    Add-UserPath
    Adds the default "..\..\bin" directory (relative to the script location) to the user's PATH, creates the directory if needed, and refreshes the session PATH.

.NOTES
    - Requires appropriate permissions to modify the user's environment variables.
    - The function will create the specified directory if it does not exist.
    - The updated PATH will be available to new processes and is also refreshed in the current session.
    - The function returns the updated PATH string.
#>
function Add-UserPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$NewPath = (Join-Path $PSScriptRoot '..\..\bin')
    )

    try {
        # Validate the new path; create if it does not exist
        if (-not (Test-Path $NewPath)) {
            Write-Host "The specified path does not exist. Creating it now..."
            New-Item -Path $NewPath -ItemType Directory -Force | Out-Null
            Write-Host "Created new directory: $NewPath"
        }
    } catch {
        Write-Error "Invalid path: $_"
        return
    }

    try {
        # Get the current user path
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
        $pathList = $currentPath -split ';'
        # Check if the new path is already in the user path
        if ($pathList -notcontains $NewPath) {
            # Append the new path to the current user path
            $updatedPath = ($pathList + $NewPath) -join ';'

            # Set the updated user path
            [Environment]::SetEnvironmentVariable("Path", $updatedPath, "User")
            Write-Host "User Path updated successfully."
        } else {
            Write-Host "The specified path ($NewPath) is already in the User Path."
        }
    } catch {
        Write-Error "An error occurred while updating the User Path: $_"
    }

    # Refresh the environment variable in the current session
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "User")

    # return the updated path
    return $env:Path
}