<#
.Synopsis
   Retrieves Domain records.
.DESCRIPTION
   Retrieves Domain records for a domain hosted with GoDaddy.
.EXAMPLE
   Get-GoDaddyDomain
   
   This example will return information on up to 50 domains associated with the API credentials
.EXAMPLE
   Get-GoDaddyDomain -Limit 200 | Select-Object Domain
   
   This example will return a list of up 200 domains associated with the API credentials
.EXAMPLE
   Get-GoDaddyDomain -Domain mydomain.com

   This example will return information about the specified domain
#>
function Get-GoDaddyDomain
{
    Param
    (
        [Parameter(Position=0)]
        [string]$Domain,
        [Parameter()]
        [int]$Limit = 50
    )

    Begin {
        $apiKeySecure = Import-Csv "$PSScriptRoot\apiKey.csv"

        # Decrypt API Key
        $apiKey = @(
            [PSCustomObject]@{
                Key = [System.Net.NetworkCredential]::new("", ($apiKeySecure.Key | ConvertTo-SecureString)).Password
                Secret = [System.Net.NetworkCredential]::new("", ($apiKeySecure.Secret | ConvertTo-SecureString)).Password
            }
        )
    }
    Process {
        #---- Build authorization header ----#
        $headers = @{}
        $headers["Authorization"] = 'sso-key ' + $apiKey.key + ':' + $apiKey.secret
        
        #---- Build the request URI based on domain ----#
        if ($Domain) {
            $uri = "https://api.godaddy.com/v1/domains/$Domain"
        } else {
            $uri = "https://api.godaddy.com/v1/domains?limit=$Limit"
        }

        #---- Make the request ----#
        $Result = Invoke-WebRequest -Uri $uri -Method Get -Headers $headers -UseBasicParsing | ConvertFrom-Json
        return $Result
    }
    End {
    }
}
