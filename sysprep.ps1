Write-Host 'Waiting for GA Service (RdAgent) to start'
While ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }

Write-Host 'Waiting for GA Service (WindowsAzureGuestAgent) to start'
While ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }

Write-Host 'Sysprepping VM'

If (Test-Path $Env:SystemRoot\system32\Sysprep\unattend.xml) {
  Remove-Item $Env:SystemRoot\system32\Sysprep\unattend.xml -Force
}
& $Env:SystemRoot\System32\Sysprep\Sysprep.exe /oobe /generalize /quiet /quit

While($True) {
  $imageState = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State).ImageState
  Write-Host $imageState
  
  If ($imageState -eq 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { break }
  Start-Sleep -s 5
}

Write-Host 'Sysprep Complete'