#Requires -RunAsAdministrator

Write-Host "WARNING: This script may apply unwanted settings to your computer!" -ForegroundColor Red
Write-Host "For more information visit: https://github.com/VideMelo/dotfiles-wsl" -ForegroundColor Red
Read-Host -Prompt "Press Enter to continue"

Remove-Item .\userInfo.txt 2> $null

Write-Host "Set Your Git Config:" -ForegroundColor Yellow
$GitName = Read-Host -Prompt "Name"
$GitEmail = Read-Host -Prompt "Email"

Write-Host "GitHub Auth (https://github.com/settings/tokens/new)" -ForegroundColor Yellow
Write-Host "Warining! Token with all scopes!" -ForegroundColor Yellow
$AuthToken = Read-Host -Prompt "Token"

New-Item "$Home\Source\Repos\dotfiles-wsl" -Force -ItemType Directory > $null

$RepoHome = Join-Path $Home '\Source\Repos'
$DotfilesRepo = Join-Path $RepoHome '\dotfiles-wsl'

$arguments = "--source=winget", "--silent", "--accept-package-agreements", '--accept-source-agreements'

function Install-WSL {
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

   wsl --set-default-version 2

   winget install --id=9PDXGNCFSCZV --source=msstore --accept-source-agreements --accept-package-agreements
}

function Install-CoreTools {
   winget install --id=Microsoft.PowerShell $arguments
   winget install --id=Git.Git $arguments
   winget install --id=GitHub.cli $arguments
}

function Get-Dotfiles {
   git config --global user.name $GitName; git config --global user.email $GitEmail; echo $AuthToken | gh auth login --with-token;
   git clone https://github.com/VideMelo/dotfiles-wsl.git $DotfilesRepo
}

function Set-Task {
   $action = New-ScheduledTaskAction -Execute powershell.exe -Argument "wt pwsh -File $DotfilesRepo\scripts\Init-Dotfiles.ps1"
   $trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERNAME"
   $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
   $principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest

   Register-ScheduledTask -TaskName "ContinueDotfilesSetup" -Action $action -Trigger $trigger -Settings $settings -Principal $principal > $null
}

Write-Host "Start getting all requeriments..."

Get-Dotfiles
Install-CoreTools
Install-WSL
Set-Task

Write-Host "Complete!! Restarting in 5 seconds..."

Start-Sleep -Seconds 5
Restart-Computer -Force
