<#
.Synopsis
   Determines whether or not the specified domain is available for purchase.
.DESCRIPTION
   Determines whether or not the specified domain is available for purchase. If the domain is taken, alternate domains are suggested.
.EXAMPLE
   PS C:\> Find-Domain google.com
   google.com is already taken.

   Alternate Domains
   -----------------
   googlebeep.com   
   googlebtc.com    
   googleiran.org   
   googleryde.com   
   googleyard.com   
   googlepot.com    
   googlebrew.com   
   googletwit.com   
   googleclip.com   
   googlepros.com   
   googletaps.com 

   This example shows a domain that's already taken and alternate available domains.
#>
function Find-Domain
{
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$Domain
    )

    Begin
    {
        $apiKey = Import-Csv "$PSScriptRoot\apiKey.csv"
    }
    Process
    {
        $Headers = @{}
        $Headers["Authorization"] = 'sso-key ' + $apiKey.key + ':' + $apiKey.secret

        $Available = Invoke-WebRequest https://api.godaddy.com/v1/domains/available?domain=$Domain -Method Get -Headers $Headers -UseBasicParsing | ConvertFrom-Json

            if($Available.available -eq 'True'){
                Write-Host "$Domain is available!"}
            else{
                Write-Host "$Domain is already taken."
                
                $Suggestions = Invoke-WebRequest https://api.godaddy.com/v1/domains/suggest?query=$Domain -Method Get -Headers $Headers -UseBasicParsing | ConvertFrom-Json
                $Suggestions | Get-Random -Count 15 | Format-Table @{e={$_.domain};l="Alternate Domains"}}
    }
    End
    {
    }
}