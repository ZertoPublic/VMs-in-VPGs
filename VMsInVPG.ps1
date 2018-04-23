#requires -Version 5
#requires -RunAsAdministrator
<#
.SYNOPSIS
   This script will list all VMs currently being protected by Zerto. 
.DESCRIPTION
   This script requires the user to enter the appropriate ZVM IP and user credentials with appropriate Rest API accesss. The script will then query the Zerto Rest API and output a list of 
   virtual machines, respective VPG Name, used storage (MB), source site, target site, and the VPG priority to the PowerShell screen. 
.EXAMPLE
   .\VMsInVPG.ps1
.VERSION 
   Applicable versions of Zerto Products script has been tested on.  Unless specified, all scripts in repository will be 5.0u3 and later.  If you have tested the script on multiple
   versions of the Zerto product, specify them here.  If this script is for a specific version or previous version of a Zerto product, note that here and specify that version 
   in the script filename.  If possible, note the changes required for that specific version.  
.LEGAL
   Legal Disclaimer:

----------------------
This script is an example script and is not supported under any Zerto support program or service.
The author and Zerto further disclaim all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose.

In no event shall Zerto, its authors or anyone else involved in the creation, production or delivery of the scripts be liable for any damages whatsoever (including, without 
limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or the inability 
to use the sample scripts or documentation, even if the author or Zerto has been advised of the possibility of such damages.  The entire risk arising out of the use or 
performance of the sample scripts and documentation remains with you.
----------------------
#>
#------------------------------------------------------------------------------#
# Declare variables
#------------------------------------------------------------------------------#
#Examples of variables:

##########################################################################################################################
#Any section containing a "GOES HERE" should be replaced and populated with your site information for the script to work.#  
##########################################################################################################################
$ZertoServer = "ZVM IP Address"
$ZertoPort = "9669"
$ZertoUser = "Zerto User"
$ZertoPassword = "Zerto Password"
$ExportCSV = "Enter Export CSV File location"
#-----------------------------------------------------------------------------#
# Setting Cert Policy
#-----------------------------------------------------------------------------#
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
#-----------------------------------------------------------------------------#
# Building Zerto API string and invoking API
#-----------------------------------------------------------------------------#
$baseURL = "https://" + $ZertoServer + ":"+$ZertoPort+"/v1/"
#-----------------------------------------------------------------------------#
# Authenticating with Zerto APIs
#-----------------------------------------------------------------------------#
$xZertoSessionURI = $baseURL + "session/add"
$authInfo = ("{0}:{1}" -f $ZertoUser,$ZertoPassword)
$authInfo = [System.Text.Encoding]::UTF8.GetBytes($authInfo)
$authInfo = [System.Convert]::ToBase64String($authInfo)
$headers = @{Authorization=("Basic {0}" -f $authInfo)}
$sessionBody = '{"AuthenticationMethod": "1"}'
$TypeJSON = "application/json"
$TypeXML = "application/xml"

Try
{
$xZertoSessionResponse = Invoke-WebRequest -Uri $xZertoSessionURI -Headers $headers -Method POST -Body $sessionBody -ContentType $TypeJSON
}
Catch
{
Write-host $_.Exception.ToString()
$error[0] | Format-List -force 
}


#-----------------------------------------------------------------------------#
#Extracting x-zerto-session from the response, and adding it to the actual API
#-----------------------------------------------------------------------------#
$xZertoSession = $xZertoSessionResponse.headers.get_item("x-zerto-session")
$zertSessionHeader_json = @{"Accept" = "application/json" 
"x-zerto-session"=$xZertoSession}
#-----------------------------------------------------------------------------#
# Querying API
#-----------------------------------------------------------------------------#
$VMListURL = $BaseURL+"vms"
$VMList = Invoke-RestMethod -Uri $VMListURL -TimeoutSec 100 -Headers $zertSessionHeader_json -ContentType $TypeJSON
$VMListTable = $VMList | select VmName, VpgName, UsedStorageInMB, SourceSite, TargetSite, Priority
$VMListTable | format-table -AutoSize
#-----------------------------------------------------------------------------#
# Exporting table to CSV
#-----------------------------------------------------------------------------#
$VMListTable | Export-CSV $ExportCSV -NoTypeInformation

#-----------------------------------------------------------------------------#
# Selecting VPG name in table
#-----------------------------------------------------------------------------#
# If selection of a specific VPG is required, uncomment the lines below
#$VMListTableFiltered = $VMListTable | Where-Object VpgName -EQ "AD DC" | format-table -AutoSize
#Write-Output $VMListTableFiltered