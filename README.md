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

You can also filter by type:

``` console
PS C:\> Get-GoDaddyDNS clintcolding.com -Type A

type name data           ttl
---- ---- ----           ---
A    @    192.30.252.153 600
A    @    192.30.252.154 600
```

Or by type **AND** name:

``` console
PS C:\> Get-GoDaddyDNS clintcolding.com -Type CNAME -Name 'www'

type  name data  ttl
----  ---- ----  ---
CNAME www  @    3600
```

### Using Add-GoDaddyDNS

`Add-GoDaddyDNS` allows you to create new DNS records. Below we'll create a new A record for test.clintcolding.com with an IP of 10.10.10.10:

``` console
PS C:\> Add-GoDaddyDNS clintcolding.com -Type A -Name test -IP 10.10.10.10

type name data         ttl
---- ---- ----         ---
A    test 10.10.10.10 3600
```

You can use `Add-GoDaddyDNS` to create records with the same name and type that point to different IPs:

``` console
PS C:\> Add-GoDaddyDNS clintcolding.com -Type A -Name test -IP 10.10.10.11

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
PS C:\> Set-GoDaddyDNS clintcolding.com -Type A -Name test -IP 10.10.10.12

type name data         ttl
---- ---- ----         ---
A    test 10.10.10.12 3600
```

And confirmed with `Get-GoDaddyDNS`:

``` console
PS C:\> Get-GoDaddyDNS clintcolding.com

type  name           data                                                                  ttl
----  ----           ----                                                                  ---
A     @              192.30.252.153                                                        600
A     @              192.30.252.154                                                        600
A     test           10.10.10.12                                                          3600
CNAME www            @                                                                    3600
```