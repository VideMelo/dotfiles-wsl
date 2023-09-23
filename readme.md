# Dotfiles WSL Setup

This project is designed to simplify the process of setting up a development environment on a Windows machine, primarily using Windows Subsystem for Linux (WSL). It provides a collection of scripts and configurations to streamline the installation of essential tools and configurations needed for a productive development workflow.

## Getting Started

Before you begin, please keep in mind the following important points:

- **Warning:** Some scripts may make system-level changes to your computer. Ensure you understand the purpose of each script before proceeding.
- To avoid problems only run if you have just formatted your computer

## Prerequisites

To successfully set up your development environment, make sure you have the following prerequisites:

- Windows 10 or later. (11 Recommended)
- PowerShell (Run as Administrator).

## Installation Worflow

Follow these steps to configure your development environment:

```pwsh
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/VideMelo/dotfiles-wsl/main/scripts/Get-Requeriments.ps1'))

```

## Customization

Feel free to tailor the configurations and scripts to match your preferences. The provided scripts and dotfiles are open for customization to suit your development needs.

If you wish to install additional development tools or software, modify the `./scripts/Install-DevelopmentTools.ps1` script accordingly.

## Troubleshooting

>**Note:** Be cautious when using this project, as some scripts can make system-level changes. Ensure you comprehend the actions performed by the scripts before proceeding.
