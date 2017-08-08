<#
.Synopsis
   Updates the API key/secret pair.
.DESCRIPTION
   Updates the API key/secret pair used by the GoDaddy module.
.EXAMPLE
   PS C:\> Set-GoDaddyAPIKey mykey mysecret

   Command        Key   Secret  
   -------        ---   ------  
   Get-GoDaddyDNS mykey mysecret
   Set-GoDaddyDNS mykey mysecret
#>
function Set-GoDaddyAPIKey
{
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$Key,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [string]$Secret
    )

    Begin
    {
    }
    Process
    {
        $apiKey = @(
            [PSCustomObject]@{
                Key = "$Key"
                Secret = "$Secret"
            }
        )
        
        $apiKey | Export-Csv -Path "$PSScriptRoot\apiKey.csv"
    }
    End
    {
    }
}