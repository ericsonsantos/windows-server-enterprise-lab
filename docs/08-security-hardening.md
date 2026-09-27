ança e Hardening

## Objetivo

Aplicar controles de segurança no domínio e configurar auditoria para gerar telemetria útil em atividades de Blue Team/SOC.

## Política de senha e bloqueio

GPO:

```text
GPO-DOMINIO-ACCOUNT-POLICY
```

Vinculada à raiz do domínio `corp.lab`.

Configurações:

```text
Password history: 10
Maximum password age: 90 days
Minimum password age: 1 day
Minimum password length: 12
Complexity: Enabled
Reversible encryption: Disabled

Account lockout threshold: 5
Account lockout duration: 15 minutes
Reset lockout counter after: 15 minutes
```

Validação:

```powershell
Get-ADDefaultDomainPasswordPolicy |
Format-List MinPasswordLength,
PasswordHistoryCount,
ComplexityEnabled,
MaxPasswordAge,
MinPasswordAge,
LockoutThreshold,
LockoutDuration,
LockoutObservationWindow
```

## Teste de bloqueio

Foram realizadas tentativas controladas de autenticação incorreta contra uma conta de laboratório.

Validação:

```powershell
Search-ADAccount -LockedOut
```

Evento analisado:

```text
4740 — A user account was locked out
```

## Advanced Audit Policy

GPO para Domain Controllers:

```text
GPO-DC-AUDITORIA-SEGURANCA
```

Subcategorias utilizadas:

```text
Audit Logon
Audit Credential Validation
Audit User Account Management
Audit Account Lockout
```

Validação:

```cmd
auditpol /get /category:*
```

## Eventos de identidade

Foram gerados e analisados:

```text
4720 — User account created
4726 — User account deleted
4728 — Member added to a global security group
4729 — Member removed from a global security group
4740 — Account locked out
4776 — Credential validation
```

## Auditoria de criação de processos

GPO:

```text
GPO-ENDPOINT-AUDITORIA
```

Vinculada à OU `Computadores`.

Configurações:

```text
Advanced Audit Policy
→ Detailed Tracking
→ Audit Process Creation
→ Success
```

Também foi habilitado:

```text
Include command line in process creation events
```

Validação:

```cmd
auditpol /get /subcategory:"Process Creation"
```

Evento:

```text
4688 — A new process has been created
```

## PowerShell Logging

Foi habilitado:

```text
Turn on PowerShell Script Block Logging
Turn on PowerShell Transcription
```

Evento analisado:

```text
4104 — PowerShell Script Block Logging
```

## Evidências sugeridas

```text
screenshots/40-domain-password-policy.png
screenshots/41-account-lockout-policy.png
screenshots/42-password-policy-validation.png
screenshots/43-account-lockout-validation.png
screenshots/44-event-4740-account-lockout.png
screenshots/45-advanced-audit-policy.png
screenshots/46-audit-policy-validation.png
screenshots/47-failed-logon-4625.png
screenshots/48-credential-validation-4776.png
screenshots/49-event-4720-user-created.png
screenshots/50-event-4726-user-deleted.png
screenshots/51-event-4728-domain-admin-added.png
screenshots/52-event-4729-domain-admin-removed.png
screenshots/53-process-creation-gpo.png
screenshots/54-event-4688-process-creation.png
screenshots/55-powershell-scriptblock-4104.png
screenshots/56-soc-recon-commands.png
screenshots/57-event-4688-investigation.png
screenshots/58-event-4104-investigation.png
screenshots/59-security-evidence-export.png
```
