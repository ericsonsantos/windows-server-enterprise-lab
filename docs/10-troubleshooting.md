# 10 — Troubleshooting

Esta seção registra alguns dos principais problemas encontrados durante a construção do laboratório e as ações utilizadas para diagnóstico e correção.

## 1. VM sem comunicação adequada com o gateway

### Sintoma

A VM não conseguia validar corretamente a comunicação com `192.168.50.1`.

### Diagnóstico

Foram verificadas:

```powershell
Get-NetIPAddress
Get-NetNat
ping 192.168.50.1
```

O NAT estava ativo, mas o firewall do host afetava testes ICMP.

### Solução

Foi criada uma regra de entrada ICMP restrita à rede:

```text
192.168.50.0/24
```

### Aprendizado

Falha de ping não significa necessariamente ausência de roteamento. Firewall e política ICMP precisam ser considerados separadamente.

---

## 2. DNS incorreto no CLIENT01

### Sintoma

`ipconfig /all` exibia DNS IPv6 `fec0::...` em vez de `192.168.50.10`.

### Diagnóstico

A opção 006 do DHCP não estava sendo entregue conforme esperado.

### Solução

No DHCP:

```text
003 Router      → 192.168.50.1
006 DNS Servers → 192.168.50.10
015 DNS Domain  → corp.lab
```

Depois no CLIENT01:

```cmd
ipconfig /release
ipconfig /renew
ipconfig /flushdns
```

---

## 3. GPO de mapeamento não aparecia

### Sintoma

A unidade `T:` não aparecia no CLIENT01.

### Diagnóstico

Foram utilizados:

```cmd
whoami
gpresult /r /scope:user
net use
```

Também foram encontradas conexões SMB abertas em contexto diferente.

### Solução

- limpar conexões de teste;
- aplicar `gpupdate /force`;
- fazer logoff/login;
- validar na sessão normal de `CORP\ericson.santos`;
- conferir Item-Level Targeting com `CORP\GG_TI`.

---

## 4. Cmdlets AD indisponíveis no File Server

### Sintoma

`Get-ADGroup` não era reconhecido no `SRV-FILE01`.

### Causa

O módulo RSAT Active Directory não estava instalado no servidor de arquivos.

### Decisão

A administração e validação dos objetos do AD permaneceram centralizadas no DC01. Não foi necessário instalar ferramentas administrativas adicionais no File Server.

---

## 5. Política de senha configurada, mas valores efetivos diferentes

### Sintoma

A GPO exibia os valores desejados, porém:

```powershell
Get-ADDefaultDomainPasswordPolicy
```

retornava outros valores.

### Diagnóstico

Foi necessário revisar:

- vínculo da GPO;
- precedência;
- escopo;
- aplicação no domínio.

### Validação

```cmd
gpresult /r /scope:computer
```

```powershell
Get-ADDefaultDomainPasswordPolicy
```

### Aprendizado

Existe diferença entre:

```text
GPO configurada
↓
GPO aplicada
↓
Política efetiva
```

---

## 6. Event ID 4625/4776 não aparecia

### Sintoma

`Get-WinEvent` não encontrava eventos recentes.

### Diagnóstico

Foi validada a política efetiva:

```cmd
auditpol /get /subcategory:"Logon"
auditpol /get /subcategory:"Credential Validation"
```

A forma de autenticação também afeta qual Event ID é produzido.

### Aprendizado

Eventos de autenticação dependem do protocolo e do host que processa a tentativa. Kerberos, NTLM e o tipo de logon podem produzir eventos diferentes.

---

## 7. Event ID 4688 não aparecia

### Sintoma

Nenhum evento 4688 era retornado no CLIENT01.

### Diagnóstico

```cmd
auditpol /get /subcategory:"Process Creation"
```

A política estava como:

```text
No Auditing
```

### Solução

Foi corrigida a GPO:

```text
Advanced Audit Policy Configuration
→ Detailed Tracking
→ Audit Process Creation
→ Success
```

Também foi habilitada a opção:

```text
Force audit policy subcategory settings to override audit policy category settings
```

Após `gpupdate /force` e reinicialização, a política passou a aparecer como `Success`.

---

## Conclusão

Os problemas encontrados durante o laboratório foram mantidos na documentação porque fazem parte do processo real de administração de infraestrutura.

O troubleshooting demonstrou uso de:

- PowerShell;
- Event Viewer;
- `gpresult`;
- `auditpol`;
- `ipconfig`;
- testes DNS;
- validação de DHCP;
- análise de permissões e sessões SMB;
- revisão de GPOs.
