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
function Update-GoDaddyAPIKey
{
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$Key,

        [Parameter(Mandatory=$true)]
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
        
        # Get module path
        
        $Paths = ((Get-Module GoDaddy | select ModuleBase).ModuleBase | Get-ChildItem | Where-Object {$_.Name -like 'Get-GoDaddy*' -or $_.Name -like 'Set-GoDaddy*' -or $_.Name -like 'Find-*'} | Select-Object FullName).FullName

        foreach ($Path in $Paths)
        {
            # Get current key
            
            [string]$KeyString = Select-String -Path $Path -Pattern "Key="
            $CurrentKey = ($KeyString.Substring($KeyString.IndexOf("'")+1)).TrimEnd(",","'")

            # Get current secret
            
            [string]$SecretString = Select-String -Path $Path -Pattern "Secret="
            $CurrentSecret = ($SecretString.Substring($SecretString.IndexOf("'")+1)).TrimEnd("'")

            # Replace current key with new key

            $Updated = (Get-Content $Path).Replace($CurrentKey,$Key)

            # Replace current key with new key

            $Updated = $Updated.Replace($CurrentSecret,$Secret)

            # Update function

            Set-Content -Path $Path -Value $Updated
        }
    }
    End
    {
    }
}