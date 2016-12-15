<#
.Synopsis
   Returns the current API key/secret pair.
.DESCRIPTION
   Returns the current API key/secret pair being used by the GoDaddy module.
.EXAMPLE
   PS C:\> Get-GoDaddyAPIKey

   Command        Key   Secret   Path                                        
   -------        ---   ------   ----                                        
   Get-GoDaddyDNS mykey mysecret C:\Users\ccolding\Documents\WindowsPowerShell\Modules\Get-GoDaddyDNS.ps1
   Set-GoDaddyDNS mykey mysecret C:\Users\ccolding\Documents\WindowsPowerShell\Modules\Set-GoDaddyDNS.ps1
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
        
        $Paths = ((Get-Module GoDaddy | select ModuleBase).ModuleBase | Get-ChildItem | Where-Object {$_.Name -like 'Get-GoDaddyDNS*' -or $_.Name -like 'Set-GoDaddyDNS*' -or $_.Name -like 'Find-*'} | Select-Object FullName).FullName

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
                        Path    = $Path
                    }
            
            $Obj=New-Object -TypeName PSObject -Property $Prop
            
            Write-Output $Obj
        }
    }
    End
    {
    }
}