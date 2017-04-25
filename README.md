# Managing GoDaddy DNS with PowerShell

To get started with this module you'll need a production [GoDaddy API Key](https://developer.godaddy.com/keys/). To set the key/secret use `Set-GoDaddyAPIKey`.

[![GoDaddy Module Demo](https://s6.postimg.org/3metixx7l/demoss.png)](http://www.youtube.com/watch?v=8vczfFLdK_Y)

## Installation

To install the GoDaddy module use `Import-Module .\GoDaddy.psd1`.

To autoload the module, copy the GoDaddy folder to `%USERPROFILE%\Documents\WindowsPowershell\Modules`.

## Work in Progress

- [x] Rework how the API secret/key is added
- [ ] Remove API secret/key in plain text
- [ ] Add certificate functions