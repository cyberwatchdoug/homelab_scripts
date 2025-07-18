<#
.SYNOPSIS
    Recursively finds .ps1 files in "src" subfolders up to two levels above the script location and creates symbolic links to them in a specified link folder.

.DESCRIPTION
    The New-SymLink function searches for all .ps1 files in "src" subdirectories starting from two levels above the script's location. 
    It ensures the link folder (default: "bin" in the script root) exists, creating it if necessary, and creates symbolic links for each .ps1 file found.
    Returns a list of all scripts linked in the link folder.

.PARAMETER LinkFolder
    The folder where symbolic links will be created. Defaults to "bin" in the script root.

.EXAMPLE
    New-SymLink
    Creates symbolic links for all .ps1 files found in "src" folders up to two levels above the script location, placing them in the "bin" folder.

.EXAMPLE
    New-SymLink -LinkFolder "custom-bin"
    Places symbolic links in the "custom-bin" folder instead of "bin".
#>
function New-SymLink {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$LinkFolder = (Join-Path $PSScriptRoot '..\..\bin')
    )

    $linkedFiles = @()
    try {
        # Find all "src" folders up to two levels above the script root
        $searchRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
        $srcFolders = Get-ChildItem -Path $searchRoot -Recurse -Directory -Filter 'src' -ErrorAction Stop

        # Find all .ps1 files in those src folders
        $ps1Files = $srcFolders | ForEach-Object {
            Get-ChildItem -Path $_.FullName -Filter '*.ps1' -File -ErrorAction Stop
        }
    } catch {
        Write-Error "Error searching for src folders or ps1 files: $_"
        return @()
    }

    # Ensure the link folder exists
    try {
        if (-not (Test-Path $LinkFolder)) {
            New-Item -Path $LinkFolder -ItemType Directory -Force | Out-Null
        }
    } catch {
        Write-Error "Failed to create link folder '$LinkFolder': $_"
        return @()
    }

    # Create symbolic links for each ps1 file
    foreach ($file in $ps1Files) {
        $linkPath = Join-Path $LinkFolder $file.Name
        try {
            # Remove existing link if it exists
            if (Test-Path $linkPath) {
                Remove-Item $linkPath -Force
            }
            New-Item -Path $linkPath -ItemType SymbolicLink -Target $file.FullName -Force | Out-Null
            $linkedFiles += $linkPath
        } catch {
            Write-Error "Failed to create symlink for $($file.FullName): $_"
        }
    }

    return $linkedFiles
}