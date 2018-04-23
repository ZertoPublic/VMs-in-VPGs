# Legal Disclaimer 
This script is an example script and is not supported under any Zerto support program or service. The author and Zerto further disclaim all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose.

In no event shall Zerto, its authors or anyone else involved in the creation, production or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or the inability to use the sample scripts or documentation, even if the author or Zerto has been advised of the possibility of such damages. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you.

# VMs in VPGs 
This script will list all VMs currently being protected by Zerto Virtual Replication. The script requires the user to enter their appropriate credentials as well as the ZVM they would like to run the script against. The script will then query the Zerto Rest API of the appropriate ZVM and and output a list of VMs that are currently protected. Within the output the VMs themselves will be listed, the VPG they are in, used storage space, source site, target site, and VPG priority. This output will be provided in a table in the PowerShell screen. 

The script will also output the table to a CSV if a hard copy is required. For selection of a specific VPG un-comment lines 105 and 106 within the script. 

# Getting Started 
Further information on this automation example can be found in section 3.3 Listing Protected VMs & VPGs in the following White Paper: http://s3.amazonaws.com/zertodownload_docs/Marketing_Material/White%20Paper%20-%20Automating%20Zerto%20Virtual%20Replication%20with%20PowerShell%20and%20REST%20APIs.pdf 

# Prerequisities 
Environment Requirements 
  - ZVR 5.0u3 +
Script Requirements 
  - ZVM IP Address
  - ZVM User with API access
  - ZVM password
  -CSV file output location 
  
# Running Script 
Once the necessary requirements have been completed select an appropriate host to run the script from. To run the script type the following:

.\VMsInVPG.ps1
