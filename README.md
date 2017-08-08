# Managing GoDaddy DNS with PowerShell

> To get started with this module you'll need a production [GoDaddy API Key](https://developer.godaddy.com/keys/). To set the key/secret use `Set-GoDaddyAPIKey`.

## Installation

To install the GoDaddy module use `Import-Module .\GoDaddy.psd1`.

To autoload the module, copy the GoDaddy folder to `%USERPROFILE%\Documents\WindowsPowershell\Modules`.

## Using Failover-GoDaddyDNS

`Failover-GoDaddyDNS` is designed to failover your DNS records from one ISP to another. 

> EXAMPLE: You host a website and have redundant ISP's, when your primary fails you want to quickly update your public DNS records to point to the secondary ISP.

It works by defining your records and corresponding IP's for a given ISP in a config.ps1 file. The data is structured in a hashtable.

```powershell
$Provider = @{

    Comcast = @{                # Your ISP
        Services = @{
            blog = '10.1.2.3'   # Your record name and IP
            "@"  = '10.1.2.4'   # Your record name and IP
        }
    }

    Level3 = @{                 # Your other ISP
        Services = @{
            blog = '20.2.3.4'   # Your record name and IP
            "@"  = '20.2.3.5'   # Your record name and IP
        }
    }
}
```

When invoking the command you specify the domain and ISP you wish to be active. 

- First, all DNS records for the given domain are returned. 
- Next the records with matching names from the config.ps1 file will be filtered. 
- Finally, `Set-GoDaddyDNS` will update the records listed with the IP corresponding to that ISP.

In the example `Failover-GoDaddyDNS -Domain clintcolding.com -ISP Comcast`, the DNS for blog.clintcolding.com will be set to 10.1.2.3 and clintcolding.com will be set to 10.1.2.4.

## Work in Progress

- [x] Rework how the API secret/key is added
- [ ] Remove API secret/key in plain text
- [ ] Add certificate functions