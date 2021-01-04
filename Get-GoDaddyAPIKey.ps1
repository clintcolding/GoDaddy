<#
.Synopsis
   Returns the current API key/secret pair.
.DESCRIPTION
   Returns the current API key/secret pair being used by the GoDaddy module.
.EXAMPLE
   PS C:\> Get-GoDaddyAPIKey

   Key    Secret   
   ---    ------   
   mykey  mysecret
#>
function Get-GoDaddyAPIKey
{
    [CmdletBinding()]

    Param
    (
    )

    Begin
    {
    }
    Process
    {       
        ## Test if apiKey.csv exists, if so, return the contents.

        if ((Test-Path "$PSScriptRoot\apiKey.csv") -eq $True) {
            $apiKeySecure = Import-Csv "$PSScriptRoot\apiKey.csv"

            # Decrypt API Key
            $apiKey = @(
                [PSCustomObject]@{
                    Key = [System.Net.NetworkCredential]::new("", ($apiKeySecure.Key | ConvertTo-SecureString)).Password
                    Secret = [System.Net.NetworkCredential]::new("", ($apiKeySecure.Secret | ConvertTo-SecureString)).Password
                }
            )

            # Return decrypted key info
            $apiKey
        }

        ## If Test-Path fails, write the following warning:

        else {
            Write-Warning -Message "API Key does not exist. Use Set-GoDaddyAPIKey to create one."
        }
    }
    End
    {
    }
}