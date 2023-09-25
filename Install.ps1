<#
.SYNOPSIS
    Install dotfiles for Windows Subsystem for Linux (WSL).

.DESCRIPTION
    This script installs dotfiles for Windows Subsystem for Linux (WSL) by downloading the dotfiles-wsl repository
    from GitHub and extracting it to a specified directory. The script sets the 'DOTFILESDIR' environment variable
    to point to the installation directory.

.PARAMETER Installdir
    Specifies the installation directory for dotfiles. The default value is the user's APPDATA directory.

#>

# Define script parameters
param(
    [Parameter(Mandatory = $false)]
    [string]$Installdir = "$env:APPDATA"
)

#Requires -RunAsAdministrator

# Define file paths and variables
$ZipFile = "$Installdir\dotfiles-wsl.zip"
$Destination = "$Installdir\dotfiles-wsl"

# Remove existing dotfiles installation if it exists
if (Test-Path $Destination) {
    Remove-Item -Path $Destination -Force
}

# Display a message indicating the start of the installation process.
Write-Host "Installing dotfiles..."

# Download the dotfiles-wsl repository from GitHub
Invoke-WebRequest -Uri https://github.com/VideMelo/dotfiles-wsl/archive/refs/heads/main.zip -OutFile $ZipFile | Out-Null

# Create the installation directory
New-Item $Destination -Force -ItemType Directory | Out-Null

# Extract the downloaded ZIP file to the installation directory
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($ZipFile, $Destination)

# Identify the first subdirectory within the extracted directory
$dir = Get-ChildItem -Path $Destination | Where-Object { $_.PSIsContainer } | Select-Object -First 1

# Move all items from the subdirectory to the installation directory
Get-ChildItem -Path $dir.FullName | Move-Item -Destination $Destination

# Remove the now-empty subdirectory and the downloaded ZIP file
Remove-Item $dir
Remove-Item $ZipFile

# Source the 'Get-Requeriments.ps1' script to continue the setup
. $Destination\scripts\Get-Requeriments.ps1