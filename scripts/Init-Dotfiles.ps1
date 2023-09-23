#Requires -RunAsAdministrator

Unregister-ScheduledTask -TaskName "ContinueDotfilesSetup" -Confirm:$false 2> $null

$ReposPath = '\Source\Repos'
$WinDotfilesPath = "/mnt/c/Users/$env:USERNAME/$ReposPath/dotfiles-wsl"

$RepoHome = Join-Path $Home $ReposPath
$DotfilesRepo = Join-Path $RepoHome '\dotfiles-wsl'

$InstallDevToolsScript = Join-Path $DotfilesRepo '\scripts\Install-DevelopmentTools.ps1'
$PowerShellProfilePath = Join-Path $DotfilesRepo '\scripts\Set-Profile.ps1'
$FontFilesPath = Join-Path $DotfilesRepo '\files\fonts\*.otf'

Write-Host "Please create a default UNIX user account." -ForegroundColor Yellow
Write-Host "The username does not need to match your Windows username." -ForegroundColor Yellow
Write-Host "For more information visit: https://aka.ms/wslusers"
$UserName = Read-Host -Prompt "Enter username"

do {
   $Pass = Read-Host -Prompt "Enter password" -AsSecureString
   $RePass = Read-Host -Prompt "Enter password again" -AsSecureString

   # Convert SecureString to plain text for comparison
   $BSTR1 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Pass)
   $BSTR2 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($RePass)
   $PassText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR1)
   $RePassText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR2)

   if ($PassText -ne $RePassText) {
      Write-Host "Passwords do not match. Please try again."
   }
   $UserPass = $PassText
} while ($PassText -ne $RePassText)

function Install-DevelopmentTools() {
   pwsh.exe $InstallDevToolsScript
}

function Install-Fonts() {
   Write-Host "Installing fonts..."

   foreach ($file in Get-ChildItem -Path $FontFilesPath -Recurse) {
      Copy-Item -Path $file.FullName -Destination "C:\Windows\Fonts"
      $fontTitle = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
      Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "$fontTitle (TrueType)" -Value $file.Name
   }
    
   Write-Host "Complete!! Fonts have been installed."
}

function Set-PowerShellProfile() {
   Write-Host "Setting PowerShell profile..."
   if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts)) {
      New-Item -ItemType File -Path $PROFILE.CurrentUserAllHosts -Force
   }
    
   Get-Content $PowerShellProfilePath | Set-Content $PROFILE.CurrentUserAllHosts
   Write-Host "Complete!! PowerShell profile has been set."
}

function Set-GitConfigurations() {
   Write-Host "Setting Git configuration..."
   git config --global core.autocrlf true
   git config --global core.editor nvim
   git config --global init.defaultBranch main
   git config --global push.autoSetupRemote true

   Write-Host "Setting Git Bash profile..."
   Copy-Item -Path $DotfilesRepo/files/.bashrc -Destination $Home/.bashrc -Force
}

function Set-WindowsTerminalSettings {
   Write-Host "Setting Windows Terminal settings..."
   # Define the path to the Windows Terminal settings
   $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

   # Save the settings to the Windows Terminal configuration file
   Copy-Item -Path $RepoHome\files\settings.json -Destination $wtSettingsPath -Force

   Write-Host "Windows Terminal settings have been applied successfully."
}

function Set-WSLDotfiles {
   Write-Host "Lauching WSL..."
   ubuntu install --root

   Write-Host "Starting WSL setup..."
   ubuntu run cp -r "$WinDotfilesPath" /root/dotfiles-wsl
   ubuntu run sh /root/dotfiles-wsl/files/wsl/launch.sh "$UserPass" "$UserName"
   ubuntu config --default-user "$UserName"
}

Write-Host "Starting initialization of dotfiles for local development on this Windows machine..."

[Environment]::SetEnvironmentVariable('REPOHOME', $RepoHome, 'User')

Install-DevelopmentTools
Install-Fonts

Set-PowerShellProfile
Set-GitConfigurations
Set-WindowsTerminalSettings
Set-WSLDotfiles

Write-Host "Complete!! Machine is ready for local Windows development."
