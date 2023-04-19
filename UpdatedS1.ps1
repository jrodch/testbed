# SentinelOne Installer
# Version 2.0
# Define Variables Here

# SentinelOne Site Token
$SentinelOneCustToken = "Token Here"

# Set the URL for the SentinelOne agent installer
$DownloadURL = "Download URL"

#Do not edit Below this line
function Get-SentinelOneInstalled {
$Global:installed = (gp HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -contains "Sentinel Agent"
$Global:s1service = Get-Service -Name "SentinelAgent" -ErrorAction SilentlyContinue
}

#SentinelOne Installation
Write-Host "Starting the SentinelOne Installation based on the variables defined in the site"
Write-Host ""
Write-Host "Checking to see if SentinelOne is already installed"

Get-SentinelOneInstalled
if ($installed -eq "True") {
Write-Host "--SentinelOne Agent already installed"
if ($s1service.Status -eq "Running") {
Write-Host "--SentinelAgent service is running"
Exit 0
}
}
else {
Write-Host "--SentinelOne is not installed"
Write-Host "SentinelAgent service is not running"
}

#Check for the Site Variables 
Write-Host ""
Write-Host "Checking the Variables"

if ($SentinelOneCustToken -eq $null) {
Write-Host "--Customer Token not set or missing"
Exit 1
}
else {
Write-Host "--CustomerToken = "$SentinelOneCustToken""
}


#SentinelOne Command Line Options
$S1Options = ""

$arguments = "/t " + $SentinelOneCustToken + $S1Options

#Check to see if a previous SentinelOne Agent installation process is running
Write-Host ""
Write-Host "Checking to see if SentinelOne Agent installation is already running"
if ((Get-Process "SentinelAgent" -ErrorAction SilentlyContinue) -eq $null) {
Write-Host "--SentinelOne Agent installation not running"
}
else {
Write-Host "SentinelOne Agent installation currently running, will kill the process before continuing"
Stop-Process -Name "SentinelAgent"
}

#Download the SentinelOne Installer
Write-Host ""
Write-Host "Downloading SentinelOne Agent Installer"
Invoke-WebRequest -Uri $DownloadURL -OutFile SentinelOneAgent.exe
if ((Test-Path SentinelOneAgent.exe) -eq "True") {
Write-Host "--SentinelOne Agent Installer downloaded successfully"
}
else {
Write-Host "--SentinelOne Agent Installer did not download - Please check Firewall or Web Filter"
Exit 1
}

#Run the installer using the arguments defined above
Write-Host ""
Write-Host "Installing SentinelOne Agent:"
Write-Host ""
Write-Host "SentinelOneAgent.exe $arguments"
Write-Host ""

Start-Process -FilePath SentinelOneAgent.exe -ArgumentList $arguments -Wait

$timeout = New-TimeSpan -Minutes 30
$install = [Diagnostics.Stopwatch]::StartNew()
while ($install.Elapsed -lt $timeout) {
if ((Get-Service "SentinelAgent" -ErrorAction SilentlyContinue)) {
Write-Host "SentinelAgent service found - breaking the loop"
Break
}
Start-Sleep -Seconds 60
}
Write-Host ""
Write-Host "SentinelOne Agent Installation Completed"