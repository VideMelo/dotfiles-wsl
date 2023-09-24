# Dotfiles WSL Setup

This project is designed to simplify the process of setting up a development environment on a Windows machine, primarily using Windows Subsystem for Linux (WSL). It provides a collection of scripts and configurations to streamline the installation of essential tools and configurations needed for a productive development workflow.

## Getting Started

**Warning:** The following Dotfiles are for my personal use. Be careful when using this repository as some scripts can make system-level changes and set unwanted settings. Make sure you understand the actions performed by the scripts before continuing. To avoid problems only run if you have just formatted your computer


## Prerequisites

To successfully set up your development environment, make sure you have the following prerequisites:

- Windows 10 or later **(11 Recommended)**
- PowerShell (Run as Administrator)

## Installation

Run this in **Powershell** as **administrator** and follow the requested instructions:

```pwsh
Set-ExecutionPolicy Unrestricted; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/VideMelo/dotfiles-wsl/main/scripts/Get-Requeriments.ps1'))
```
> **Attention**, your computer may restart a few times during installation!

## Customization

Feel free to tailor the configurations and scripts to match your preferences. The provided scripts and dotfiles are open for customization to suit your development needs.

If you wish to install additional development tools or software, modify the `./scripts/Install-DevelopmentTools.ps1` script accordingly.
