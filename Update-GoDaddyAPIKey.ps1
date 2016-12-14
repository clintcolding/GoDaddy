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
        
        $Path = Get-Module GoDaddyDNS | Select-Object Path
        $Path = ($Path.Path).TrimEnd('GoDaddyDNS.psd1')
        $Path = $Path + "Get-GoDaddyDNS.ps1"

        # Get current key

        [string]$String = Select-String -Path $Path -Pattern "Key="
        $CurrentKey = ($String.Substring($String.IndexOf("'")+1)).TrimEnd(",","'")

        # Replace current key with new key

        $Updated = (Get-Content $Path).Replace($CurrentKey,$Key)

        # Update function

        Set-Content -Path $Path -Value $Updated
    }
    End
    {
    }
}