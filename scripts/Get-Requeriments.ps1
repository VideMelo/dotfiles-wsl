<#
.SYNOPSIS
    Configure a Windows machine for local development using dotfiles within Windows Subsystem for Linux (WSL).

.DESCRIPTION
    This script automates the setup of a Windows machine for local development using dotfiles in Windows Subsystem for Linux (WSL).
    It enables required features, installs core tools, sets Git configurations, and schedules a task for continuing the setup.

    WARNING: This script may apply settings that modify your computer. Make sure to read the documentation at 
    https://github.com/VideMelo/dotfiles-wsl for more information.

    Your computer may restart during installation.

.NOTES
    This script should be run with Administrator privileges.

    Follow the prompts to configure Git, provide an authentication token, and continue with the installation.
#>

# Requires Administrator privileges to run.
#Requires -RunAsAdministrator

Write-Host "WARNING: This script may apply unwanted settings to your computer!" -ForegroundColor Red
Write-Host "For more information visit: https://github.com/VideMelo/dotfiles-wsl" -ForegroundColor Red
Write-Host "Your computer may restart a few times during installation!" -ForegroundColor Yellow
Read-Host -Prompt "Press Enter to continue"

Write-Host "Set Your Git Config:" -ForegroundColor Yellow
$GitName = Read-Host -Prompt "Name"
$GitEmail = Read-Host -Prompt "Email"

Write-Host "GitHub Auth (https://github.com/settings/tokens/new)" -ForegroundColor Yellow
Write-Host "Warining! Token with all scopes!" -ForegroundColor Yellow
$AuthToken = Read-Host -Prompt "Token"

Powercfg -change -standby-timeout-ac 0

$Dotfiles = Split-Path $PSScriptRoot -Parent

. $Dotfiles\scripts\RefreshEnv.ps1

function Install-Package {
   param (
      [Parameter(Mandatory = $true)]
      [string]$Id,
      [Parameter(Mandatory = $false)]
      [string]$Source = "winget",
      [Parameter(Mandatory = $true)]
      [string]$Name = "Package"
   )
   
   try {
      Write-Host "Instaling $Name..."
      winget install --id=$Id --source=$Source --accept-source-agreements --accept-package-agreements --silent | Out-Null
      Write-Host "Package sucessfully installed!" -ForegroundColor Blue
   }
   catch {
      Write-Host "The package could not be installed!" -ForegroundColor Red
   }
}

function Install-WSL {
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart | Out-Null
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart | Out-Null
   
   Install-Package -Id 9PDXGNCFSCZV -Source msstore -Name ubuntu
}

function Install-CoreTools {
   Install-Package -Id Microsoft.PowerShell -Name "Powershell 7"
   Install-Package -Id Git.Git -Name "Git"
   Install-Package -Id GitHub.cli -Name "GitHun CLI"

   Update-SessionEnvironment
}

function Get-Dotfiles {
   git config --global user.name $GitName; git config --global user.email $GitEmail
   Write-Output $AuthToken | gh auth login --with-token
   git clone https://github.com/VideMelo/dotfiles-wsl.git $Dotfiles
}

function Set-Task {
   $action = New-ScheduledTaskAction -Execute powershell.exe -Argument "wt pwsh -File $Dotfiles\scripts\Init-Dotfiles.ps1"
   $trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERNAME"
   $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
   $principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest
   Register-ScheduledTask -TaskName "ContinueDotfilesSetup" -Action $action -Trigger $trigger -Settings $settings -Principal $principal | Out-Null
}


Write-Host "Start getting all requeriments..."

Install-CoreTools
Get-Dotfiles
Install-WSL
Set-Task

. $Dotfiles\scripts\Set-WindowsConfigs.ps1

Write-Host "Complete!! Restarting in 5 seconds..."

Start-Sleep -Seconds 5
Restart-Computer -Force
