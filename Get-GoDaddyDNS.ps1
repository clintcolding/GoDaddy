<#
.Synopsis
   Retrieves DNS records.
.DESCRIPTION
   Retrieves DNS records for a domain hosted with GoDaddy.
.EXAMPLE
   Get-GoDaddyDNS google.com
   
   This example will return all DNS records for google.com.
.EXAMPLE
   Get-GoDaddyDNS -Domain google.com -Type A

   This example will return all A records for google.com.
.EXAMPLE
   Get-GoDaddyDNS -Domain google.com -Type A -Name mail

   This example will return all A records with the name mail for google.com.
#>
function Get-GoDaddyDNS
{
    [CmdletBinding(DefaultParameterSetName='Default')]

    Param
    (
        [Parameter(ParameterSetName='Default',
                   Mandatory=$true,
                   Position=0)]
        [Parameter(ParameterSetName='Optional',
                   Mandatory=$true,
                   Position=0)]
        [string]$Domain,

        [Parameter(ParameterSetName='Optional',
                   Mandatory=$true,
                   Position=1)]
        [ValidateSet('A','CNAME','MX','TXT','NS','SRV','AAAA')]
        [string]$Type,

        [Parameter(ParameterSetName='Optional')]
        [string]$Name,

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
        
        try{
            Invoke-WebRequest https://api.godaddy.com/v1/domains/$Domain/records/$Type/$Name -Method Get -Headers $Headers | ConvertFrom-Json
        }
        catch [System.Net.WebException]{
            Write-Warning 'API key and/or secret is incorrect for Get-GoDaddyDNS.'
        }
    }
    End
    {
    }
}