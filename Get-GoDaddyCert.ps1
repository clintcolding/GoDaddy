<#
.Synopsis
   Retrieves DNS records.
.DESCRIPTION
   Retrieves DNS records for a domain hosted with GoDaddy.
.EXAMPLE
   Get-GoDaddyDNS google.com
   
   This example will return all DNS records for google.com.
.EXAMPLE
   Get-GoDaddyDNS -Domain google.com -Type A

   This example will return all A records for google.com.
.EXAMPLE
   Get-GoDaddyDNS -Domain google.com -Type A -Name mail

   This example will return all A records with the name mail for google.com.
#>
function Get-GoDaddyCert
{
    [CmdletBinding()]

    Param
    (

        [string]$CertID,

        [switch]$Active
    )

    Begin
    {
        $apiKey = Import-Csv "$PSScriptRoot\apiKey.csv"
    }
    Process
    {                
        $Headers = @{}
        $Headers["Authorization"] = 'sso-key ' + $apiKey.key + ':' + $apiKey.secret
        
        try{
            $Certs = Invoke-WebRequest https://api.godaddy.com/v1/Certificates/$CertID -Method Get -Headers $Headers -UseBasicParsing | ConvertFrom-Json
        }
        catch [System.Net.WebException]{
            Write-Error 'API key and/or secret is incorrect for Get-GoDaddyDNS.'
        }
        
        if($Active){
            $Certs | where {$_.active -eq 'True'}
        }

        else{
            $Certs
        }
    }
    End
    {
    }
}
