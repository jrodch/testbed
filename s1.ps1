# URL and Destination
New-Item -Path 'C:\S1Install' -ItemType Directory
$url = "http://157.230.7.34/downloads/SentinelOneInstaller.exe"
$dest = "c:\S1Install"

# Download file
Start-BitsTransfer -Source $url -Destination $dest 
C:\S1Install\SentinelOneInstaller.exe -t Put_Token_Here -a="/NORESTART"