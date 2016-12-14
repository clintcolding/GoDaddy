#Managing GoDaddy DNS with PowerShell

To get started with these functions you'll need a production [GoDaddy API Key](https://developer.godaddy.com/keys/).

The API Key and Secret are set as the default parameter values. You can update these values by using the 'Update-GoDaddyAPIKey'.

![API Key/Secret Values](https://s6.postimg.org/n7i2cunhd/pssnip.png)

##GoDaddy Module

To import the GoDaddy module use `Import-Module .\GoDaddy.psd1`.

To autoload the module, copy the GoDaddy folder to `%USERPROFILE%\Documents\WindowsPowershell\Modules`.

##Work in Progress

- [x] Rework how the API secret/key is added
- [ ] Remove API secret/key in plain text
- [ ] Add certificate functions