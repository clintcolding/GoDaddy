<#
.Synopsis
   Creates or updates DNS records.
.DESCRIPTION
   Creates or updates DNS records for domains hosted with GoDaddy.
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
        [int]$TTL=3600,

        [string]$Key='VVJ5Su5y_R5KQ2tW8fUWw2yqyftgCRA',

        [string]$Secret='R5KTt7RXBHJR9RCMn7jpkc'
    )

    Begin
    {
    }
    Process
    {        
        $Headers = @{}
        $Headers["Authorization"] = 'sso-key ' + $Key + ':' + $Secret

        $Record = @{data="$IP";ttl=$TTL}
        $Body = ConvertTo-Json $Record

        try{
            Invoke-WebRequest https://api.godaddy.com/v1/domains/$Domain/records/$Type/$Name -Method Put -Headers $Headers -Body $Body -ContentType "application/json" | Out-Null
        }
        catch [System.Net.WebException]{
            Write-Warning 'API key and/or secret is incorrect for Set-GoDaddyDNS.'
        }

        Get-GoDaddyDNS -Domain $Domain -Type $Type -Name $Name
    }
    End
    {
    }
}