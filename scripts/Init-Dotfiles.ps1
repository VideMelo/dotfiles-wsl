#Requires -RunAsAdministrator

Unregister-ScheduledTask -TaskName "ContinueDotfilesSetup" -Confirm:$false 2> $null

$RepoHome = Join-Path $Home '\Source\Repos'
$DotfilesRepo = Join-Path $RepoHome '\dotfiles-wsl'
# The script has not run before, so execute the first part of the script

$InstallDevToolsScript = Join-Path $DotfilesRepo '\scripts\Install-DevelopmentTools.ps1'
$PowerShellProfilePath = Join-Path $DotfilesRepo '\scripts\Set-Profile.ps1'
$FontFilesPath = Join-Path $DotfilesRepo '\files\fonts\*.otf'

Write-Host "Linux User:" -ForegroundColor Yellow
$UserName = Read-Host -Prompt "Name"

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
   git config --global core.autocrlf true
   git config --global core.editor nvim
   git config --global init.defaultBranch main
   git config --global push.autoSetupRemote true
}

function Set-Wallpaper() {
   winget install --id=Microsoft.BingWallpaper --source=winget
}

# Define the path to the settings.json file here
$SettingsJsonPath = ".\files\settings.json"

function Set-WindowsTerminalSettings {
   Write-Host "Setting Windows Terminal settings..."

   try {
      # Define the path to the Windows Terminal settings
      $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

      # Save the settings to the Windows Terminal configuration file
      Copy-Item -Path $SettingsJsonPath -Destination $wtSettingsPath -Force

      Write-Host "Windows Terminal settings have been applied successfully."
   }
   catch {
      Write-Host "An error occurred while applying Windows Terminal settings: $_"
   }
}

function Set-WSLDotfiles {
   Write-Host "Lauching WSL..."
   Start-Job -ScriptBlock { ubuntu } > $null
   Start-Sleep -Seconds 10

   wsl git clone https://github.com/VideMelo/dotfiles-wsl.git /root/dotfiles-wsl
   wsl chmod +x /root/dotfiles-wsl/files/wsl/setup.sh
   wsl sudo /root/dotfiles-wsl/files/wsl/setup.sh
}

Write-Host "Starting initialization of dotfiles for local development on this Windows machine..."

[Environment]::SetEnvironmentVariable('REPOHOME', $RepoHome, 'User')

# Install-DevelopmentTools
# Install-Fonts

# Set-PowerShellProfile
# Set-GitConfigurations
# Set-Wallpaper
# Set-WindowsTerminalSettings
Set-WSLDotfiles

Write-Host "Complete!! Machine is ready for local Windows development."
