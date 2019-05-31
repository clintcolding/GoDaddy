<#
.Synopsis
   Retrieves DNS records.
.DESCRIPTION
   Retrieves DNS records for a domain hosted with GoDaddy.
.EXAMPLE
   Get-GoDaddyDNS google.com
   
   This example will return all DNS records for google.com.
.EXAMPLE
   Get-GoDaddyDNS -Domain google.com | Where-Object {$_.Type -eq "A"}

   This example will return all A records for google.com.
#>
function Get-GoDaddyDNS
{
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$Domain
    )

    Begin {
        $apiKey = Import-Csv "$PSScriptRoot\apiKey.csv"
    }
    Process {
        #---- Build authorization header ----#
        $headers = @{}
        $headers["Authorization"] = 'sso-key ' + $apiKey.key + ':' + $apiKey.secret
        
        #---- Build the request URI based on domain ----#
        $uri = "https://api.godaddy.com/v1/domains/$Domain/records"

        #---- Make the request ----#
        $request = Invoke-WebRequest -Uri $uri -Method Get -Headers $headers -UseBasicParsing | ConvertFrom-Json

        #---- Convert the request data into an object ----#
        foreach ($item in $request) {
            [PSCustomObject]@{
                data = $item.data
                name = $item.name
                ttl  = $item.ttl
                type = $item.type
            }
        }
    }
    End {
    }
}
