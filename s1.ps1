<#
    .SYNOPSIS
    Windows deployment script for SentinelOne.
    .Instructions
    Download the lasted GA version of the EXE from the S1 management console.  
	Rename the installer to "SentinelOneInstaller.exe"
	You will input the URL for that site replacing "Enter URL".
	You will need to input your SentinelOne Site or Group Token, replacing "Put_Token_Here".
    .NOTES
    Jarrod Higgins
    10-07-22
    
	
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
This script is not officially supported by Pax8 or SentinelOne. 
#>   

# URL and Destination
New-Item -Path 'C:\S1Install' -ItemType Directory
$url = "http://157.230.7.34/downloads/SentinelOneInstaller.exe"
$dest = "c:\S1Install"

# Download file
Start-BitsTransfer -Source $url -Destination $dest 
C:\S1Install\SentinelOneInstaller.exe -t eyJ1cmwiOiAiaHR0cHM6Ly91c2VhMS0zMDAtbmZyLnNlbnRpbmVsb25lLm5ldCIsICJzaXRlX2tleSI6ICJnXzAwYWE0MDk5MTdiOGRjYjAifQ== -a="/NORESTART"
