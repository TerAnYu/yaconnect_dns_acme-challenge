<#
"Yandex.DNS letsencrypt"
Author	: TerAnYu
GitHub	: https://github.com/TerAnYu/yaconnect_dns_acme-challenge
Date	: 24/06/2020
Version	: 0.2
#>

Param(
 [string]$action,
 [string]$domain,
 [string]$subdomain,
 [string]$text
)

$subdomain = $subdomain -replace "([_a-zA-Z0-9].+).($domain)",'$1'
$timeoutsec = 600

# https://yandex.ru/dev/pdd/doc/concepts/access-docpage/
$token="YOUR_TOKEN_PDD______________________________________"

# https://github.com/PKISharp/win-acme/wiki/DNS-validation-plugins

if ( $action -eq "create" ) {
iwr https://pddimp.yandex.ru/api2/admin/dns/add `
	-UseBasicParsing `
    -Method 'POST' `
    -Headers @{'PddToken' = $token} `
    -Body @{'domain'=$domain;'type'='TXT';'subdomain'=$subdomain;'ttl'='5';'content'=$text}
Wait-Event -Timeout $timeoutsec
}

elseif ( $action -eq "delete" ) {
$records=(
iwr https://pddimp.yandex.ru/api2/admin/dns/list `
    -UseBasicParsing `
    -Headers @{'PddToken' = $token} `
    -Body @{'domain'=$domain}
).Content
$json = ConvertFrom-Json -InputObject $records
[xml]$xml = ConvertTo-Xml -Depth 2000 -InputObject $json -NoTypeInformation

# $record_id=(($xml).SelectNodes("//Property") | Where {$_.'#text' -eq '_acme-challenge'} | ForEach {$_.ParentNode.ChildNodes.Where({$_.Name -eq 'record_id'})} | ForEach-Object { $_.'#text' })
$record_id=(($xml).SelectNodes("//Property") | Where {$_.'#text' -eq '_acme-challenge'} | ForEach {$_.ParentNode.ChildNodes.Where({$_.Name -eq 'record_id'})}).'#text'

if ($record_id -ne "") {
iwr https://pddimp.yandex.ru/api2/admin/dns/del `
    -UseBasicParsing `
    -Method 'POST' `
    -Headers @{'PddToken' = $token} `
    -Body @{'domain'=$domain;'type'='TXT';'record_id'=$record_id}
}
Wait-Event -Timeout $timeoutsec
}

else { Write-Warning("Error action!") }