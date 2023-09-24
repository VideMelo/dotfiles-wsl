$zipfile = "$Home\dotfiles-wsl.zip"
$destination = "$Home\Source\Repos\dotfiles-wsl"

Write-Host "Installing dotfiles..."
Invoke-WebRequest -Uri https://github.com/VideMelo/dotfiles-wsl/archive/refs/heads/main.zip -OutFile $zipfile

New-Item $destination -Force -ItemType Directory > $null
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $destination)
$dir = Get-ChildItem -Path $destination | Where-Object { $_.PSIsContainer } | Select-Object -First 1
Get-ChildItem -Path $dir.FullName | Move-Item -Destination $destination

Remove-Item $dir
Remove-Item $zipfile

. $destination\scripts\Get-Requeriments.ps1