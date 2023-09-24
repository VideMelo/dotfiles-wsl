#Requires -RunAsAdministrator

$arguments = "--silent", "--accept-package-agreements", '--accept-source-agreements'

function Install-PowerUserTools() {
   winget install --id=Microsoft.WindowsTerminal --source=winget $arguments
   winget install --id=Microsoft.PowerShell --source=winget $arguments
   winget install --id=JanDeDobbeleer.OhMyPosh --source=winget $arguments
   winget install --id=Microsoft.PowerToys --source=winget $arguments
}

function Install-CoreWebTools() {
   winget install --id=OpenJS.Nodejs --source=winget $arguments
   winget install --id=Postman.Postman --source=winget $arguments
}

function Install-PythonTools() {
   winget install --id=9NRWMJP3717K --source=winget $arguments # Python 3.11 and Pip
}

function Install-CoreDotNetTools() {
   winget install --id=Microsoft.DotNet.SDK.7
   winget install --id=Microsoft.VisualStudioCode --source=winget $arguments
   winget install --id=Microsoft.VisualStudio.2022.Community --source=winget $arguments
   winget install --id=Microsoft.NuGet --source=winget $arguments
   winget install --id=Docker.DockerDesktop --source=winget $arguments
}

function Install-SocialTools() {
   winget install --id=Discord.Discord --source=winget $arguments
   winget install --id=Spotify.Spotify --source=winget $arguments
   winget install --id=Telegram.TelegramDesktop  --source=winget $arguments
   winget install --id=WhatsApp.WhatsApp --source=winget $arguments
}

Write-Host "Installing local development tools..."

Install-PowerUserTools
Install-CoreDotNetTools
Install-PythonTools
Install-CoreWebTools
Install-SocialTools

Write-Host "Complete!! Development tools installed successfully. Restarting in 5 Seconds..."