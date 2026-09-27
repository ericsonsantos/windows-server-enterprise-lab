# 03 — Active Directory

## Objetivo

Transformar o DC01 em Domain Controller e criar a base lógica do domínio `corp.lab`.

## Instalação do AD DS

No DC01:

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

Promoção para novo forest:

```powershell
Install-ADDSForest `
  -DomainName "corp.lab" `
  -DomainNetbiosName "CORP"
```

Após reinicialização, o servidor passou a operar como Domain Controller.

## Validação

```powershell
Get-ADDomain
Get-ADForest
Get-ADDomainController
```

Informações principais:

```text
Domain: corp.lab
Forest: corp.lab
Domain Controller: DC01.corp.lab
IPv4: 192.168.50.10
Global Catalog: True
```

## Estrutura de OUs

```text
OU=TI
OU=Financeiro
OU=RH
OU=Comercial
OU=Operacoes
OU=Servidores
OU=Computadores
```

Exemplo de criação:

```powershell
New-ADOrganizationalUnit -Name "TI" -Path "DC=corp,DC=lab"
```

## Ingresso dos computadores

O `CLIENT01` e o `SRV-FILE01` foram ingressados no domínio `corp.lab`.

Exemplo:

```powershell
Add-Computer `
  -DomainName "corp.lab" `
  -Credential (Get-Credential "CORP\Administrator") `
  -Restart
```

Após o ingresso:

- `CLIENT01` foi movido para `OU=Computadores`.
- `SRV-FILE01` foi movido para `OU=Servidores`.

## Evidências sugeridas

```text
screenshots/07-ad-ds-dns-installed.png
screenshots/08-dc01-domain-controller.png
screenshots/10-ou-structure.png
```
