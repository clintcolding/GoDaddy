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
function Get-GoDaddyDNS
{
    [CmdletBinding(DefaultParameterSetName='Default')]

    Param
    (
        [Parameter(ParameterSetName='Default',
                   Mandatory=$true,
                   Position=0)]
        [Parameter(ParameterSetName='Optional',
                   Mandatory=$true,
                   Position=0)]
        [string]$Domain,

        [Parameter(ParameterSetName='Optional',
                   Mandatory=$true,
                   Position=1)]
        [ValidateSet('A', 'AAAA', 'CNAME', 'MX', 'NS', 'SOA', 'SRV', 'TXT')]
        [string]$Type,

        [Parameter(ParameterSetName='Optional')]
        [string]$Name
    )

    Begin
    {
        $apiKey = Import-Csv "$PSScriptRoot\apiKey.csv"
    }
    Process
    {     
        $Headers = @{}
        $Headers["Authorization"] = 'sso-key ' + $apiKey.key + ':' + $apiKey.secret
        
        if ($Type) {
            Invoke-WebRequest https://api.godaddy.com/v1/domains/$Domain/records/$Type/$Name -Method Get -Headers $Headers -UseBasicParsing | ConvertFrom-Json
        }

        else {
            Invoke-WebRequest https://api.godaddy.com/v1/domains/$Domain/records -Method Get -Headers $Headers -UseBasicParsing | ConvertFrom-Json
        }
    }
    End
    {
    }
}
