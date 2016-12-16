#Managing GoDaddy DNS with PowerShell

To get started with these functions you'll need a production [GoDaddy API Key](https://developer.godaddy.com/keys/).

The API Key and Secret are set as the default parameter values. These values can be changed by using 'Set-GoDaddyAPIKey'.

[![GoDaddy Module Demo](http://img.youtube.com/vi/8vczfFLdK_Y/0.jpg)](http://www.youtube.com/watch?v=8vczfFLdK_Y)

##GoDaddy Module

To import the GoDaddy module use `Import-Module .\GoDaddy.psd1`.

To autoload the module, copy the GoDaddy folder to `%USERPROFILE%\Documents\WindowsPowershell\Modules`.

##Work in Progress

- [x] Rework how the API secret/key is added
- [ ] Remove API secret/key in plain text
- [ ] Add certificate functions