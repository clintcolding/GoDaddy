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
        Import-Csv "$PSScriptRoot\apiKey.csv"
    }
    End
    {
    }
}