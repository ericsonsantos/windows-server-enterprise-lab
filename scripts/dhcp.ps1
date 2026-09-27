<#
.SYNOPSIS
    Configuração do DHCP IPv4 do laboratório corp.lab.

.DESCRIPTION
    Executar no DC01 como Administrador.
#>

$ServerIP = "192.168.50.10"
$ScopeId = "192.168.50.0"

Install-WindowsFeature DHCP -IncludeManagementTools

Import-Module DhcpServer

if (-not (Get-DhcpServerInDC | Where-Object IPAddress -eq $ServerIP)) {
    Add-DhcpServerInDC -DnsName "DC01.corp.lab" -IPAddress $ServerIP
}

if (-not (Get-DhcpServerv4Scope -ScopeId $ScopeId -ErrorAction SilentlyContinue)) {
    Add-DhcpServerv4Scope `
        -Name "CORP-LAN" `
        -StartRange 192.168.50.110 `
        -EndRange 192.168.50.199 `
        -SubnetMask 255.255.255.0 `
        -State Active
}

Set-DhcpServerv4OptionValue `
    -ScopeId $ScopeId `
    -Router 192.168.50.1 `
    -DnsServer 192.168.50.10 `
    -DnsDomain "corp.lab"

Write-Host "Escopo DHCP:"
Get-DhcpServerv4Scope -ScopeId $ScopeId

Write-Host "Opções do escopo:"
Get-DhcpServerv4OptionValue -ScopeId $ScopeId
