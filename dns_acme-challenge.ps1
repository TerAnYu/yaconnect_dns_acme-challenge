Param(
 [string]$action,
 [string]$domain,
 [string]$subdomain,
 [string]$text
)

$subdomain = $subdomain -replace "([_a-zA-Z0-9].+).($domain)",'$1'
$token="YOUR_TOKEN_PDD______________________________________"



if ( $action -eq "create" ) {
iwr https://pddimp.yandex.ru/api2/admin/dns/add `
    -Method 'POST' `
    -Headers @{'PddToken' = $token} `
    -Body @{'domain'=$domain;'type'='TXT';'subdomain'=$subdomain;'ttl'='10';'content'=$text}
}


elseif ( $action -eq "delete" ) {
$records=(
iwr https://pddimp.yandex.ru/api2/admin/dns/list `
    -Headers @{'PddToken' = $token} `
    -Body @{'domain'=$domain}
).Content
$json = ConvertFrom-Json -InputObject $records
[xml]$xml = ConvertTo-Xml -Depth 2000 -InputObject $json -NoTypeInformation

# $record_id=(($xml).SelectNodes("//Property") | Where {$_.'#text' -eq '_acme-challenge'} | ForEach {$_.ParentNode.ChildNodes.Where({$_.Name -eq 'record_id'})} | ForEach-Object { $_.'#text' })
$record_id=(($xml).SelectNodes("//Property") | Where {$_.'#text' -eq '_acme-challenge'} | ForEach {$_.ParentNode.ChildNodes.Where({$_.Name -eq 'record_id'})}).'#text'

if ($record_id -ne "") {
iwr https://pddimp.yandex.ru/api2/admin/dns/del `
    -Method 'POST' `
    -Headers @{'PddToken' = $token} `
    -Body @{'domain'=$domain;'type'='TXT';'record_id'=$record_id}
}
}

else { Write-Warning("Error action!") }
