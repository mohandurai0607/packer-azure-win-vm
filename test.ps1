{
  "type": "powershell",
  "inline": [
    # Enable TLS 1.2 in the registry
    "Write-Output 'Enabling TLS 1.2 in the registry...'",
    "$regPath = 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\TLS 1.2\\Client'",
    
    "if (-not (Test-Path \"$regPath\\DisabledByDefault\")) {",
    "    New-ItemProperty -Path $regPath -Name 'DisabledByDefault' -PropertyType 'DWORD' -Value 0 -Force",
    "} else {",
    "    Set-ItemProperty -Path $regPath -Name 'DisabledByDefault' -Value 0",
    "}",
    
    "if (-not (Test-Path \"$regPath\\Enabled\")) {",
    "    New-ItemProperty -Path $regPath -Name 'Enabled' -PropertyType 'DWORD' -Value 1 -Force",
    "} else {",
    "    Set-ItemProperty -Path $regPath -Name 'Enabled' -Value 1",
    "}",
    
    "Write-Output 'TLS 1.2 has been enabled in the registry.'",

    # Optional: Force TLS 1.2 for the current session
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12",
    "Write-Output 'TLS 1.2 is enforced for the current session.'",

    # Install Chocolatey
    "Write-Output 'Installing Chocolatey...'",
    "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))",
    "Write-Output 'Chocolatey installed.'",

    # Install Node.js using Chocolatey
    "Write-Output 'Installing Node.js...'",
    "choco install nodejs -y",
    "Write-Output 'Node.js installed.'"
  ]
}
