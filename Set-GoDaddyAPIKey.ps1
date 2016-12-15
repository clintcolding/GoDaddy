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
        
        $Var = Get-GoDaddyAPIKey

        foreach ($Cmd in $Var)
        {
            # Get current key
            
            $CurrentKey = $Cmd.Key

            # Get current secret
            
            $CurrentSecret = $Cmd.Secret

            # Replace current key with new key

            $Updated = (Get-Content $Cmd.Path).Replace($CurrentKey,$Key)

            # Replace current key with new key

            $Updated = $Updated.Replace($CurrentSecret,$Secret)

            # Update function

            Set-Content -Path $Cmd.Path -Value $Updated
        }

        Get-GoDaddyAPIKey
    }
    End
    {
    }
}