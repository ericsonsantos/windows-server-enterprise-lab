ver

## Objetivo

Criar um servidor de arquivos departamental com controle de acesso baseado em grupos do Active Directory.

## Servidor

```text
Hostname: SRV-FILE01
IP: 192.168.50.20
Domínio: corp.lab
```

Segundo disco utilizado para dados:

```text
E:\
```

Estrutura:

```text
E:\Shares\
├── TI
├── Financeiro
├── RH
├── Comercial
└── Operacoes
```

## Permissões

Exemplo para TI:

```powershell
$Admins = (Get-LocalGroup -SID "S-1-5-32-544").Name

icacls "E:\Shares\TI" /inheritance:r
icacls "E:\Shares\TI" /grant "${Admins}:(OI)(CI)F"
icacls "E:\Shares\TI" /grant "SYSTEM:(OI)(CI)F"
icacls "E:\Shares\TI" /grant "CORP\DL_TI_RW:(OI)(CI)M"
```

## Compartilhamento SMB

```powershell
New-SmbShare `
  -Name "TI" `
  -Path "E:\Shares\TI" `
  -ChangeAccess "CORP\DL_TI_RW"
```

Mesmo padrão aplicado aos demais departamentos.

## Testes

Usuário:

```text
CORP\ericson.santos
```

Deve conseguir acessar:

```text
\\SRV-FILE01\TI
```

E não deve conseguir acessar compartilhamentos de outros departamentos quando não possuir o grupo correspondente.

## Mapeamento

A unidade do setor de TI foi mapeada automaticamente:

```text
T: → \\SRV-FILE01\TI
```

## Evidências sugeridas

```text
screenshots/22-srv-file01-vm.png
screenshots/23-srv-file01-network.png
screenshots/24-srv-file01-domain-joined.png
screenshots/25-srv-file01-server-ou.png
screenshots/26-data-volume.png
screenshots/28-department-shares-folders.png
screenshots/29-smb-department-shares.png
screenshots/30-ti-share-permissions.png
screenshots/31-ti-access-allowed.png
screenshots/32-financeiro-access-denied.png
```
