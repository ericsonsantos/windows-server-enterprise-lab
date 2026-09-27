# 06 — Group Policy

## Objetivo

Aplicar configurações de computador e usuário de forma centralizada através do Active Directory.

## GPO — Mensagem de logon

Nome:

```text
GPO-COMPUTADORES-MENSAGEM-LOGON
```

Vinculada à OU `Computadores`.

Caminho:

```text
Computer Configuration
→ Policies
→ Windows Settings
→ Security Settings
→ Local Policies
→ Security Options
```

Configurações:

```text
Interactive logon: Message title
CORP - Acesso ao ambiente corporativo

Interactive logon: Message text
Este equipamento pertence ao ambiente corporativo CORP.
O acesso é permitido somente a usuários autorizados.
```

## GPO — Restrições de usuário TI

Nome:

```text
GPO-TI-USUARIO-RESTRICOES
```

Vinculada à OU `TI`.

Configuração utilizada:

```text
User Configuration
→ Policies
→ Administrative Templates
→ Start Menu and Taskbar
→ Remove Run menu from Start Menu
```

## GPO — Mapeamento de unidade

Nome:

```text
GPO-TI-MAP-DRIVE
```

Mapeamento:

```text
T: → \\SRV-FILE01\TI
```

Implementado com Group Policy Preferences:

```text
User Configuration
→ Preferences
→ Windows Settings
→ Drive Maps
```

Item-Level Targeting:

```text
User is a member of CORP\GG_TI
```

## Validação

```cmd
gpupdate /force
gpresult /r
net use
```

Resultado esperado:

```text
T:  \\SRV-FILE01\TI
```

## Troubleshooting

O mapeamento não apareceu inicialmente porque os testes estavam sendo realizados em contextos diferentes de sessão e com conexões SMB já abertas. A validação foi refeita na sessão normal do usuário `CORP\ericson.santos`, seguida de logoff/login.

## Evidências sugeridas

```text
screenshots/17-gpo-logon-policy.png
screenshots/18-gpresult-client01.png
screenshots/19-corporate-logon-message.png
screenshots/20-user-gpo-ti.png
screenshots/21-gpresult-user-policy.png
screenshots/33-gpo-drive-map-config.png
screenshots/34-drive-map-targeting.png
screenshots/35-client01-mapped-drive.png
```
