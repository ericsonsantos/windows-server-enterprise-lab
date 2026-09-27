# 04 — DNS e DHCP

## DNS

O DC01 utiliza o próprio endereço como servidor DNS:

```text
192.168.50.10
```

Isso permite que os computadores do domínio resolvam registros e serviços do Active Directory.

### Forwarders

Para resolução de nomes externos foram configurados forwarders:

```text
1.1.1.1
8.8.8.8
```

Exemplo:

```powershell
Add-DnsServerForwarder -IPAddress 1.1.1.1
Add-DnsServerForwarder -IPAddress 8.8.8.8
```

Validação:

```powershell
Get-DnsServerForwarder
Resolve-DnsName dc01.corp.lab
Resolve-DnsName microsoft.com -Server 192.168.50.10
```

## DHCP

O DHCP foi instalado no DC01:

```powershell
Install-WindowsFeature DHCP -IncludeManagementTools
```

Autorização no Active Directory:

```powershell
Add-DhcpServerInDC `
  -DnsName "DC01.corp.lab" `
  -IPAddress 192.168.50.10
```

Validação:

```powershell
Get-DhcpServerInDC
```

## Escopo

```text
Nome: CORP-LAN
Rede: 192.168.50.0/24
Faixa: 192.168.50.110 - 192.168.50.199
Gateway: 192.168.50.1
DNS: 192.168.50.10
Domínio DNS: corp.lab
```

Criação:

```powershell
Add-DhcpServerv4Scope `
  -Name "CORP-LAN" `
  -StartRange 192.168.50.110 `
  -EndRange 192.168.50.199 `
  -SubnetMask 255.255.255.0 `
  -State Active
```

Opções:

```powershell
Set-DhcpServerv4OptionValue `
  -ScopeId 192.168.50.0 `
  -Router 192.168.50.1 `
  -DnsServer 192.168.50.10 `
  -DnsDomain "corp.lab"
```

## Cliente

No CLIENT01:

```cmd
ipconfig /release
ipconfig /renew
ipconfig /all
```

A configuração correta deve apontar:

```text
DHCP Server: 192.168.50.10
Default Gateway: 192.168.50.1
DNS Servers: 192.168.50.10
```

## Troubleshooting

Durante a configuração, o cliente chegou a exibir servidores DNS `fec0::...`. O problema foi resolvido corrigindo a opção 006 do DHCP para entregar `192.168.50.10` e renovando a concessão no CLIENT01.

## Evidências sugeridas

```text
screenshots/09-dns-validation.png
screenshots/36-dhcp-scope.png
screenshots/37-dhcp-scope-options.png
screenshots/38-client01-dhcp-ipconfig.png
screenshots/39-dhcp-client01-lease.png
```
