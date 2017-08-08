function Failover-GoDaddyDNS
{
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$Domain,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [string]$ISP
    )

    Begin
    {
        . .\config.ps1

        $Apps = ($Provider.$ISP.Services).keys
    }
    Process
    {
        $DNSRecords = Get-GoDaddyDNS -Domain $Domain

        $Filter = foreach ($App in $Apps) {
            $DNSRecords | Where-Object {$_.name -eq "$App"} | select name,type,ttl,data
        }

        foreach($Record in $Filter){
            Set-GoDaddyDNS -Domain $Domain -Type $Record.type -Name $Record.name -TTL $Record.ttl -IP $Provider.$ISP.Services.($Record.Name)
        }
    }
    End
    {
    }
}