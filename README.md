# Managing GoDaddy DNS with PowerShell

This module allows you to quickly view, create, and edit DNS entries within your GoDaddy account.

## Using the GoDaddy DNS Module

### Installation

To install the GoDaddy module use `Import-Module .\GoDaddy.psd1`.

To autoload the module, copy the GoDaddy folder to `%USERPROFILE%\Documents\WindowsPowershell\Modules`.

### Configuring API Key

To get started with this module you'll need a production [GoDaddy API Key](https://developer.godaddy.com/keys/).

To set the key/secret pair, use `Set-GoDaddyAPIKey`:

``` console
PS C:\> Set-GoDaddyAPIKey -Key 2s7Yn1f2dW_VrYQjtDRMhdqQhy5zUMd7r -Secret VrYT3z2eEW8tfPsNJViCRA
```

To confirm, use `Get-GoDaddyAPIKey`:

``` console
PS C:\> Get-GoDaddyAPIKey

Key                               Secret
---                               ------
2s7Yn1f2dW_VrYQjtDRMhdqQhy5zUMd7r VrYT3z2eEW8tfPsNJViCRA
```

### Using Get-GoDaddyDNS

Once your keys are configured you can use `Get-GoDaddyDNS` against any domain within your account:

``` console
PS C:\> Get-GoDaddyDNS clintcolding.com

type  name           data                                                                  ttl
----  ----           ----                                                                  ---
A     @              192.30.252.153                                                        600
A     @              192.30.252.154                                                        600
CNAME www            @                                                                    3600
```

### Using Get-GoDaddyDomain

Once your keys are configured you can use `Get-GoDaddyDomain` to get information about all your domains or a specific domain:

``` console

# Gets information on up to 50 domains by default
PS C:\> Get-GoDaddyDomain

createdAt           : 2018-05-08T11:01:20.000Z
domain              : mygreatdomain.com
domainId            : 1111111111
...

# Get information on up to 200 domains associated with API credentials and returns just a list of domain names
PS C:\> Get-GoDaddyDomain -Limit 200 | Select-Object Domain

domain
------
adomain.com
bdomain.com
cdomain.ski

# Get information for a specific domain
PS C:\> Get-GoDaddyDomain -Domain mydomain.com

authCode            : 123456ABCDEF
contactAdmin        : @{addressMailing=; email=admin@mydomain.com; fax=; nameFirst=John; nameLast=Smith; organization=My Organization; phone=+1.1234567890}
contactBilling      : @{addressMailing=; email=admin@mydomain.com; fax=; nameFirst=John; nameLast=Smith; organization=My Organization; phone=+1.1234567890}
domain              : mydomain.com
...

```

### Using Add-GoDaddyDNS

`Add-GoDaddyDNS` allows you to create new DNS records. Below we'll create a new A record for test.clintcolding.com with an Data of 10.10.10.10:

``` console
PS C:\> Add-GoDaddyDNS clintcolding.com -Type A -Name test -Data 10.10.10.10

type name data         ttl
---- ---- ----         ---
A    test 10.10.10.10 3600
```

You can use `Add-GoDaddyDNS` to create records with the same name and type that point to different IPs:

``` console
PS C:\> Add-GoDaddyDNS clintcolding.com -Type A -Name test -Data 10.10.10.11

type name data         ttl
---- ---- ----         ---
A    test 10.10.10.10 3600
A    test 10.10.10.11 3600
```

> You can also optionally define the TTL value using the `TTL` parameter.

### Using Set-GoDaddyDNS

`Set-GoDaddyDNS` allows you to update DNS records. If you have multiple records with the same name and type, `Set-GoDaddyDNS` will replace them with the new record.

Using `Get-GoDaddyDNS` below, you can see we have two A records for *test*:

``` console
PS C:\> Get-GoDaddyDNS clintcolding.com

type  name           data                                                                  ttl
----  ----           ----                                                                  ---
A     @              192.30.252.153                                                        600
A     @              192.30.252.154                                                        600
A     test           10.10.10.10                                                          3600
A     test           10.10.10.11                                                          3600
CNAME www            @                                                                    3600
```

Using `Set-GoDaddyDNS` to update the A records for *test* will replace both of them with our new record:

``` console
PS C:\> Set-GoDaddyDNS clintcolding.com -Type A -Name test -Data 10.10.10.12

type name data         ttl
---- ---- ----         ---
A    test 10.10.10.12 3600
```

### Adding and Setting SRV Records

When adding or setting SRV records, additional parameters are required. (Service, Priority, Protocol, Port, Weight)

If you run `Add-GoDaddyDNS -Domain clintcolding.com -Type SRV`, you will be prompted for the remaining required parameters.

Alternatively, you can explicitly name them all:

``` console
PS C:\> Add-GoDaddyDNS -Domain clintcolding.com -Type SRV -Name test -Data targethost.clintcolding.com -Service sip -Priority 10 -Protocol tcp -Port 5060 -Weight 10

type     : SRV
name     : test
data     : targethost.clintcolding.com
service  : _sip
protocol : _tcp
port     : 5060
weight   : 10
priority : 10
ttl      : 3600
```

You can further confirm using `Get-GoDaddyDNS`:

``` console
PS C:\> Get-GoDaddyDNS clintcolding.com

type  name  data                              ttl
----  ----  ----                              ---
SRV   test  targethost.clintcolding.com       3600
```
