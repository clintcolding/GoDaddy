<#
.SYNOPSIS
   Removes a DNS record from a GoDaddy-hosted domain.
.DESCRIPTION
   Removes a specified DNS record from a domain hosted with GoDaddy using the GoDaddy API.
.PARAMETER Domain
   The domain name from which to remove the DNS record.
.PARAMETER RecordType
   The type of DNS record to remove (A, AAAA, CNAME, MX, NS, SRV, or TXT).
.PARAMETER Name
   The name of the DNS record to remove.
.EXAMPLE
   Remove-GoDaddyDNSRecord -Domain "example.com" -RecordType A -Name "www"
   
   This example removes the A record for "www" from the domain "example.com".
.NOTES
   This function requires a valid GoDaddy API key and secret to be set using Set-GoDaddyAPIKey.
#>
function Remove-GoDaddyDNSRecord {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Domain,
        [Parameter(Mandatory=$true)]
        [ValidateSet('A','AAAA','CNAME','MX','NS','SRV','TXT')]
        [string]$RecordType,
        [Parameter(Mandatory=$true)]
        [string]$Name
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
        # Build authorization header
        $headers = @{
            "Authorization" = "sso-key $($apiKey.Key):$($apiKey.Secret)"
            "Accept" = "application/json"
        }
        # Build the request URI
        $uri = "https://api.godaddy.com/v1/domains/$Domain/records/$RecordType/$Name"
        try {
            # Make the DELETE request
            $response = Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers
            Write-Host "Successfully deleted $RecordType record for $Name.$Domain"
        }
        catch {
            Write-Error "Failed to delete $RecordType record for $Name.$Domain`: $_"
        }
    }
}