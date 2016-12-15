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
        # Get module path
        
        $Paths = ((Get-Module GoDaddyDNS | select ModuleBase).ModuleBase | Get-ChildItem | Where-Object {$_.Name -like 'Get-GoDaddyDNS*' -or $_.Name -like 'Set-GoDaddyDNS*' -or $_.Name -like 'Find-*'} | Select-Object FullName).FullName

        foreach ($Path in $Paths)
        {
            # Get current key
            
            [string]$KeyString = Select-String -Path $Path -Pattern "Key="
            $CurrentKey = ($KeyString.Substring($KeyString.IndexOf("'")+1)).TrimEnd(",","'")

            # Get current secret
            
            [string]$SecretString = Select-String -Path $Path -Pattern "Secret="
            $CurrentSecret = ($SecretString.Substring($SecretString.IndexOf("'")+1)).TrimEnd("'")

            $Prop = [ordered] @{
                        Command = ($Path | Get-ChildItem -Name).TrimEnd(".ps1")
                        Key     = $CurrentKey
                        Secret  = $CurrentSecret
                    }
            
            $Obj=New-Object -TypeName PSObject -Property $Prop
            
            Write-Output $Obj
        }
    }
    End
    {
    }
}