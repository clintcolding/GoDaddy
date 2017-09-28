<#
.Synopsis
   Updates DNS records.
.DESCRIPTION
   Updates DNS records for domains hosted with GoDaddy. If multiple records exist with the same name and type, Set-GoDaddyDNS will replace them all.
.EXAMPLE
   Set-GoDaddyDNS -Domain google.com -Type A -Name mail -IP 8.8.8.8

   This example creates an A records for google.com with the name mail and an IP of 8.8.8.8.
#>
function Set-GoDaddyDNS
{
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$Domain,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [ValidateSet('A','CNAME','MX','TXT','NS','SRV','AAAA')]
        [string]$Type,

        [Parameter(Mandatory=$true,
                   Position=2)]
        [string]$Name,

        [Parameter(Mandatory=$true,
                   Position=3)]
        [ipaddress]$IP,
        
        [Parameter(Position=4)]
        [int]$TTL=3600
    )

    Begin
    {
        $apiKey = Import-Csv "$PSScriptRoot\apiKey.csv"
    }
    Process
    {        
        $Headers = @{}
        $Headers["Authorization"] = 'sso-key ' + $apiKey.key + ':' + $apiKey.secret

        $Record = @{data="$IP";ttl=$TTL}
        $Body = ConvertTo-Json $Record

        Invoke-WebRequest https://api.godaddy.com/v1/domains/$Domain/records/$Type/$Name -Method Put -Headers $Headers -Body $Body -ContentType "application/json" -UseBasicParsing | Out-Null

        Get-GoDaddyDNS -Domain $Domain -Type $Type -Name $Name
    }
    End
    {
    }
}
