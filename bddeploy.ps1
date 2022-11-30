<#
    .SYNOPSIS
    Windows deployment script for BitDefender.
    .Instructions
    First you will need to get your company hash.  In GravityZone go to Packages. Choose the package you want to deploy and click "Send Download Links".  Copy the alphanumeric code at the end of the Windows Downloader 
    link (Do not include the square brackets).  This is your company hash.  Paste it below under "$CompanyHash".
    .NOTES
    Jarrod Higgins
    10-07-22
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
This script is not officially supported by Pax8 or SentinelOne. 
#>  

$CompanyHash = ""

### Modify below this line.

# If it's already installed, just do nothing
$Installed = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
Where-Object { $_.DisplayName -eq "Bitdefender Endpoint Security Tools" }

if ($Installed) {
    Write-Output "Bitdefender already installed. Exiting."
    Exit 0
}

$BitdefenderURL = "setupdownloader_[$CompanyHash].exe"
$BaseURL = "https://cloud.gravityzone.bitdefender.com/Packages/BSTWIN/0/"
$URL = $BaseURL + $BitdefenderURL
$Destination = 'C:\Windows\Temp\setupdownloader.exe'

try 
{
    Write-Output "Beginning download of Bitdefender to $Destination"
    Invoke-WebRequest -Uri $URL -OutFile $Destination
}
catch
{
    Write-Output "Error Downloading - $_.Exception.Response.StatusCode.value_"
    Write-Output $_
    Exit 1
}

# Check if a previous attempt failed, leaving the installer in the temp directory and breaking the script
$FullDestination = "$DestinationPath\setupdownloader_[$CompanyHash].exe"
if (Test-Path $FullDestination) {
   Remove-Item $FullDestination
   Write-Out "Removed $FullDestination..."
}

Rename-Item -Path $Destination -NewName "setupdownloader_[$CompanyHash].exe"
Write-Output "Download succeeded, beginning install..."
Start-Process -FilePath "C:\Windows\Temp\$BitdefenderURL" -ArgumentList "/bdparams /silent silent" -Wait -NoNewWindow

# Wait an additional 30 seconds after the installer process completes to verify installation
Start-Sleep -Seconds 30

$Installed = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
Where-Object { $_.DisplayName -eq "Bitdefender Endpoint Security Tools" }

if ($Installed) {
    Write-Output "Bitdefender successfully installed."
    Exit 0
}
else {
    Write-Output "ERROR: Failed to install Bitdefender"
    Exit 1
}
