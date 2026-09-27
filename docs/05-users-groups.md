# 05 — Usuários e Grupos

## Objetivo

Criar uma estrutura de identidade e autorização baseada em departamentos, aplicando o modelo AGDLP.

## Usuários

| Nome | SamAccountName | OU |
|---|---|---|
| Ericson Santos | `ericson.santos` | TI |
| Ana Silva | `ana.silva` | Financeiro |
| Mariana Costa | `mariana.costa` | RH |
| Carlos Souza | `carlos.souza` | Comercial |
| Lucas Oliveira | `lucas.oliveira` | Operacoes |

## Grupos globais

```text
GG_TI
GG_FINANCEIRO
GG_RH
GG_COMERCIAL
GG_OPERACOES
```

Os usuários foram adicionados ao grupo global correspondente ao seu departamento.

## Grupos Domain Local

```text
DL_TI_RW
DL_FINANCEIRO_RW
DL_RH_RW
DL_COMERCIAL_RW
DL_OPERACOES_RW
```

## AGDLP

Modelo aplicado:

```text
Accounts
   ↓
Global Groups
   ↓
Domain Local Groups
   ↓
Permissions
```

Exemplo:

```text
ericson.santos
   ↓
GG_TI
   ↓
DL_TI_RW
   ↓
Permissão Modify em E:\Shares\TI
```

## Exemplos PowerShell

Criar grupo global:

```powershell
New-ADGroup `
  -Name "GG_TI" `
  -GroupScope Global `
  -GroupCategory Security `
  -Path "OU=TI,DC=corp,DC=lab"
```

Criar grupo Domain Local:

```powershell
New-ADGroup `
  -Name "DL_TI_RW" `
  -GroupScope DomainLocal `
  -GroupCategory Security
```

Nesting:

```powershell
Add-ADGroupMember -Identity "DL_TI_RW" -Members "GG_TI"
```

## Validação

```powershell
Get-ADGroupMember GG_TI
Get-ADGroupMember DL_TI_RW
```

## Evidências sugeridas

```text
screenshots/11-security-groups.png
screenshots/12-users-group-membership.png
screenshots/27-agdlp-groups.png
```
