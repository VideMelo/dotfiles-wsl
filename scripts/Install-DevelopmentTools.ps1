#Requires -RunAsAdministrator

$arguments = "--silent", "--accept-package-agreements", '--accept-source-agreements'

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

function Install-PowerUserTools() {
   Install-Package -Id Microsoft.WindowsTerminal -Name "Windows Terminal"
   Install-Package -Id Microsoft.PowerShell -Name PowerShell
   Install-Package -Id JanDeDobbeleer.OhMyPosh -Name OhMyPosh
   Install-Package -Id Microsoft.PowerToys -Name PowerToys
}

function Install-CoreWebTools() {
   Install-Package -Id OpenJS.Nodejs -Name NodeJS
   Install-Package -Id Postman.Postman -Name Postman
}

function Install-PythonTools() {
   Install-Package -Id 9NRWMJP3717K -Source msstore -Name Python
}

function Install-CoreDotNetTools() {
   Install-Package -Id Microsoft.DotNet.SDK.7 -Name "DotNet SDK"
   Install-Package -Id Microsoft.VisualStudioCode -Name VisualStudio
   Install-Package -Id Microsoft.VisualStudio.2022.Community -Name "VisualStudio 2022 Community"
   Install-Package -Id Microsoft.NuGet -Name Nuget
   Install-Package -Id Docker.DockerDesktop -Name "Docker Desktop"
}

function Install-SocialTools() {
   Install-Package -Id Discord.Discord -Name Discord
   Install-Package -Id Spotify.Spotify -Name Spotify
   Install-Package -Id Telegram.TelegramDesktop -Name "Telegram Desktop"
   Install-Package -Id WhatsApp.WhatsApp -Name "WhatsApp"
}

Write-Host "Installing local development tools..."

Install-PowerUserTools
Install-CoreDotNetTools
Install-PythonTools
Install-CoreWebTools
Install-SocialTools

Write-Host "Complete!! Development tools installed successfully."