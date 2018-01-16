<#
.Synopsis
   Adds new DNS records.
.DESCRIPTION
   Adds a new DNS record for domains hosted with GoDaddy. Useful for creating multiple records with the same name.
.EXAMPLE
   Add-GoDaddyDNS clintcolding.com -Type A -Name "test" -IP 10.10.10.14

   type name data         ttl
   ---- ---- ----         ---
   A    test 10.10.10.13 3600
   A    test 10.10.10.14 3600
#>
function Add-GoDaddyDNS
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
        [string]$Data,
        
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
        $Headers["Content-Type"] = "application/json"
        $Headers["Accept"] = "application/json"

        $Record = @{type="$Type";name="$Name";data="$Data";ttl=$TTL}
        $Body = "[" + (ConvertTo-Json $Record) + "]"

        Invoke-WebRequest https://api.godaddy.com/v1/domains/$Domain/records -Method Patch -Headers $Headers -Body $Body -UseBasicParsing | ConvertFrom-Json

        Get-GoDaddyDNS -Domain $Domain -Type $Type -Name $Name
    }
    End
    {
    }
}
