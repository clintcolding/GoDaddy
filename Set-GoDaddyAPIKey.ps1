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
        if ($Key -eq $Secret) {
            Write-Error 'Key and Secret cannot be the same.'
            break
        }
        
        $Data = Get-GoDaddyAPIKey

        foreach ($Entry in $Data)
        {
            # Replace current key with new key

            $Updated = (Get-Content $Entry.Path).Replace($Entry.Key,$Key)

            # Replace current key with new key

            $Updated = $Updated.Replace($Entry.Secret,$Secret)

            # Update functions

            Set-Content -Path $Entry.Path -Value $Updated
        }

        Get-GoDaddyAPIKey | Select-Object Command,Key,Secret
    }
    End
    {
    }
}