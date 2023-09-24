param(
    [Parameter(Mandatory=$false)]
    [string]$InstallIn = "$env:APPDATA"
)

$ZipFile = "$Home\dotfiles-wsl.zip"
$Destination = "$InstallIn\dotfiles-wsl"

if(Test-Path $Destination) {
   Remove-Item -Path $Destination -Force
}

[Environment]::SetEnvironmentVariable('DOTFILESDIR', $Destination, 'User')

Write-Host "Installing dotfiles..."
Invoke-WebRequest -Uri https://github.com/VideMelo/dotfiles-wsl/archive/refs/heads/main.zip -OutFile $ZipFile

New-Item $Destination -Force -ItemType Directory > $null
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($ZipFile, $Destination)
$dir = Get-ChildItem -Path $Destination | Where-Object { $_.PSIsContainer } | Select-Object -First 1
Get-ChildItem -Path $dir.FullName | Move-Item -Destination $Destination

Remove-Item $dir
Remove-Item $ZipFile

. $Destination\scripts\Get-Requeriments.ps1