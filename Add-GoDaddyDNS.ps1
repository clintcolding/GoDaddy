<#
.Synopsis
   Adds new DNS records.
.DESCRIPTION
   Adds a new DNS record for domains hosted with GoDaddy. Useful for creating multiple records with the same name.
.EXAMPLE
   Add-GoDaddyDNS clintcolding.com -Type A -Name "test" -IP 10.10.10.14

   type name data         ttl
   ---- ---- ----         ---
   A    test 10.10.10.13 3600
   A    test 10.10.10.14 3600
#>
function Add-GoDaddyDNS
{
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$Domain,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [ValidateSet('A','CNAME','MX','TXT','NS','SRV','AAAA')]
        [string]$Type,

        [Parameter(Mandatory=$true,
                   Position=2)]
        [string]$Name,

        [Parameter(Mandatory=$true,
                   Position=3)]
        [string]$Data,
        
        [Parameter(Position=4)]
        [int]$TTL=3600
    )

    DynamicParam {
        if ($Type -eq "SRV") {
            # Inititalize runtime dictionary
            $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

            # Priority ParameterAttribute object
            $priorityAttribute = New-Object System.Management.Automation.ParameterAttribute
            $priorityAttribute.Mandatory = $true
            $priorityAttribute.HelpMessage = "Please enter record priority:"

            # AttributeCollection object for the above attribute
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

            # Add attribute to collection
            $attributeCollection.Add($priorityAttribute)

            # Add paramater specifying the attribute collection
            $priorityParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Priority', [int32], $attributeCollection)

            # Service ParameterAttribute object
            $serviceAttribute = New-Object System.Management.Automation.ParameterAttribute
            $serviceAttribute.Mandatory = $true
            $serviceAttribute.HelpMessage = "Please enter SRV service:"

            # AttributeCollection object for the above attribute
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

            # Add attribute to collection
            $attributeCollection.Add($serviceAttribute)

            # Add paramater specifying the attribute collection
            $serviceParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Service', [string], $attributeCollection)

            # Protocol ParameterAttribute object
            $protocolAttribute = New-Object System.Management.Automation.ParameterAttribute
            $protocolAttribute.Mandatory = $true
            $protocolAttribute.HelpMessage = "Please enter SRV protocol:"

            # AttributeCollection object for the above attribute
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

            # Add attribute to collection
            $attributeCollection.Add($protocolAttribute)

            # Add paramater specifying the attribute collection
            $protocolParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Protocol', [string], $attributeCollection)

            # Port ParameterAttribute object
            $portAttribute = New-Object System.Management.Automation.ParameterAttribute
            $portAttribute.Mandatory = $true
            $portAttribute.HelpMessage = "Please enter SRV port:"

            # AttributeCollection object for the above attribute
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

            # Add attribute to collection
            $attributeCollection.Add($portAttribute)

            # Add paramater specifying the attribute collection
            $portParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Port', [int32], $attributeCollection)

            # Weight ParameterAttribute object
            $weightAttribute = New-Object System.Management.Automation.ParameterAttribute
            $weightAttribute.Mandatory = $true
            $weightAttribute.HelpMessage = "Please enter SRV weight:"

            # AttributeCollection object for the above attribute
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

            # Add attribute to collection
            $attributeCollection.Add($weightAttribute)

            # Add paramater specifying the attribute collection
            $weightParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Weight', [int32], $attributeCollection)

            #Add the names of our parameters
            $paramDictionary.Add('Priority', $priorityParam)
            $paramDictionary.Add('Service', $serviceParam)
            $paramDictionary.Add('Protocol', $protocolParam)
            $paramDictionary.Add('Port', $portParam)
            $paramDictionary.Add('Weight', $weightParam)

            return $paramDictionary
        }
    }

    Begin
    {
        $apiKey = Import-Csv "$PSScriptRoot\apiKey.csv"
    }
    Process
    {
        #---- Build authorization header ----#
        $headers = @{}
        $headers["Authorization"] = 'sso-key ' + $apiKey.key + ':' + $apiKey.secret
        $headers["Content-Type"] = "application/json"
        $headers["Accept"] = "application/json"

        #---- If SRV, build SRV record ----#
        if ($Type -eq "SRV") {
            $record = @{type="$Type";name="$Name";data="$Data";ttl=$TTL;priority=$PSBoundParameters.Priority;service="{0}" -f $PSBoundParameters.Service;protocol="{0}" -f $PSBoundParameters.Protocol;port=$PSBoundParameters.Port;weight=$PSBoundParameters.Weight}
            $body = "[" + (ConvertTo-Json $record) + "]"
        }
        #---- Build standard record ----#
        else {
            $record = @{type="$Type";name="$Name";data="$Data";ttl=$TTL}
            $body = "[" + (ConvertTo-Json $record) + "]"
        }

        #---- Build the request URI based on domain ----#
        $uri = "https://api.godaddy.com/v1/domains/$Domain/records"
        #---- Make the request ----#
        Invoke-WebRequest -Uri $uri -Method Patch -Headers $headers -Body $body -UseBasicParsing | ConvertFrom-Json
        #---- Validate record with Get-GoDaddyDNS ----$
        Get-GoDaddyDNS -Domain $Domain | Where-Object {$_.type -eq $Type -and $_.name -eq $Name -and $_.data -eq $Data}
    }
    End
    {
    }
}
