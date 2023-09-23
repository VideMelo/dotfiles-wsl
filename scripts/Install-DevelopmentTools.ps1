#Requires -RunAsAdministrator

$arguments = "--source=winget", "--silent", "--accept-package-agreements", '--accept-source-agreements'

function Install-PowerUserTools() {
   winget install --id=Microsoft.WindowsTerminal $arguments
   winget install --id=Microsoft.PowerShell $arguments
   winget install --id=JanDeDobbeleer.OhMyPosh $arguments
   winget install --id=Microsoft.PowerToys $arguments
}

function Install-CoreWebTools() {
   winget install --id=OpenJS.Nodejs $arguments
   winget install --id=Postman.Postman $arguments
}

function Install-PythonTools() {
   winget install --id=Python.Python $arguments
   winget install --id=Python.Pip $arguments
}

function Install-CoreDotNetTools() {
   winget install --id=Microsoft.DotNet.SDK.7
   winget install --id=Microsoft.VisualStudioCode $arguments
   winget install --id=Microsoft.VisualStudio.2022.Community $arguments
   winget install --id=Microsoft.NuGet $arguments
   winget install --id=Docker.DockerDesktop $arguments
}

function Install-SocialTools() {
   winget install --id=Discord.Discord $arguments
   winget install --id=Spotify.Spotify $arguments
   winget install --id=Telegram.TelegramDesktop  $arguments
   winget install --id=WhatsApp.WhatsApp $arguments
}

Write-Host "Installing local development tools..."

Install-PowerUserTools
Install-CoreDotNetTools
Install-PythonTools
Install-CoreWebTools
Install-SocialTools

Write-Host "Complete!! Development tools installed successfully. Restarting in 5 Seconds..."