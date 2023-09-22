<#
    .SYNOPSIS
    Windows deployment script for Perimeter81.
    .Instructions
    
    Jarrod Higgins
    2023-9-22
    
	
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
This script is not officially supported by Pax8 or Perimeter81. 
#>   


# URL and Destination
New-Item -Path 'C:\P81Install' -ItemType Directory
$url = "https://static.perimeter81.com/agents/windows/Perimeter81_10.1.1.1438.msi"
$dest = "C:\P81Install"

# Download file
Start-BitsTransfer -Source $url -Destination $dest 
msiexec /passive /qn /i c:\P81Install\Perimeter81_10.1.1.1438.msi
