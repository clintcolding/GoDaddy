<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
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