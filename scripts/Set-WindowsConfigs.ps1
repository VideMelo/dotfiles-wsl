function Remove-PreInstalledApps {
   Write-Host "Removing pre installed applications..."
   $BlockedAppsList =    
   "Clipchamp.Clipchamp
                Microsoft.549981C3F5F10
                Microsoft.GamingApp
                Microsoft.GetHelp
                Microsoft.Getstarted
                Microsoft.MicrosoftOfficeHub
                Microsoft.MicrosoftSolitaireCollection
                Microsoft.People
                Microsoft.PowerAutomateDesktop
                Microsoft.Todos
                Microsoft.WindowsCommunicationsApps
                Microsoft.WindowsFeedbackHub
                Microsoft.WindowsMaps
                Microsoft.Xbox.TCUI
                Microsoft.XboxGameOverlay
                Microsoft.XboxGamingOverlay
                Microsoft.XboxIdentityProvider
                Microsoft.XboxSpeechToTextOverlay
                Microsoft.YourPhone
                Microsoft.ZuneMusic
                Microsoft.ZuneVideo
                MicrosoftTeams"

   $SplitBlockedAppsList = $BlockedAppsList -split "`n" | Foreach-Object { $_.trim() }

   $BlockedAppsListArray = New-Object -TypeName System.Collections.ArrayList
   foreach ($app in $SplitBlockedAppsList) {
      $BlockedAppsListArray.AddRange(@($app))
   }

   if ($($BlockedAppsListArray.Count) -ne 0) {
      Write-Host "Apps marked for removal: $($BlockedAppsListArray)" -ForegroundColor Blue

      $InstalledApps = Get-AppxProvisionedPackage -Online | Select-Object -ExpandProperty DisplayName
      
      foreach ($app in $InstalledApps) {
         try {
            $AppxProvisioningPackageName = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $app } | Select-Object -ExpandProperty PackageName -First 1
            Write-Host "$($app) found.  Attemping removal..." -ForegroundColor Blue
            
            $RemoveAppx = Remove-AppxProvisionedPackage -PackageName $AppxProvisioningPackageName -Online -AllUsers
            
            $AppxProvisioningPackageNameReCheck = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $app } | Select-Object -ExpandProperty PackageName -First 1
            
            if ([string]::IsNullOrEmpty($AppxProvisioningPackageNameReCheck) -and ($RemoveAppx.Online -eq $true)) {
               Write-Host "$($app) removed." -ForegroundColor Blue
            }
         }
         catch {
            Write-Host "Error attempting to remove $($AppToRemove)" -ForegroundColor Red
         }
      }
   }
   else {
      Write-Host "Blocked Apps list could not be processed." -ForegroundColor Red
   }
}

function Set-DarkTheme {
   Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
   Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
}

Write-Host "Setting Windows configurations..."

Remove-PreInstalledApps
Set-DarkTheme

Write-Host "Settings set successfully!" -ForegroundColor Blue
