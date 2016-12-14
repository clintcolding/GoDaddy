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
        # Get and set module path
        
        $Paths = ((Get-Module GoDaddyDNS | select ModuleBase).ModuleBase | Get-ChildItem | Where-Object {$_.Name -like 'Get*' -or $_.Name -like 'Set*'} | Select-Object FullName).FullName

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