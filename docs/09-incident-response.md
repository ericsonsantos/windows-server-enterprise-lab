# 09 — Incident Response

## Título

**Atividade de reconhecimento controlada no CLIENT01**

## 1. Resumo

Durante um exercício controlado no laboratório `corp.lab`, foram executados comandos de reconhecimento no endpoint `CLIENT01`.

O objetivo foi validar a capacidade de auditoria do Windows, identificar processos executados e analisar eventos registrados no Security Log e no log operacional do PowerShell.

## 2. Ambiente

```text
Domínio: corp.lab
Endpoint: CLIENT01
Domain Controller: DC01
Usuário: CORP\ericson.santos
```

## 3. Atividade executada

Comandos de reconhecimento benignos:

```text
whoami
hostname
ipconfig
net user
net localgroup
Get-Process
Get-Service
```

A atividade foi realizada exclusivamente para fins educacionais no ambiente de laboratório.

## 4. Evidências

### Event ID 4688

O Event ID 4688 registra criação de processos.

Com a auditoria configurada, foi possível observar:

- horário da execução;
- usuário;
- processo criado;
- processo pai;
- linha de comando quando disponível.

### Event ID 4104

O PowerShell Script Block Logging fornece visibilidade sobre conteúdo executado dentro do PowerShell.

Esse evento complementa a análise do 4688.

## 5. Linha do tempo

A linha do tempo deve ser preenchida com os horários efetivamente observados nos logs.

Exemplo de estrutura:

| Horário | Host | Evento | Descrição |
|---|---|---:|---|
| HH:MM:SS | CLIENT01 | 4688 | Processo criado |
| HH:MM:SS | CLIENT01 | 4104 | Script block registrado |

> Não inserir horários que não estejam presentes nas evidências reais.

## 6. Análise

As atividades observadas corresponderam ao exercício controlado realizado no laboratório.

Não foram utilizados malware, exploração ou persistência. O foco foi testar a visibilidade fornecida pelos recursos nativos de auditoria do Windows.

## 7. Resposta

Fluxo executado:

1. Identificação dos eventos.
2. Correlação por horário e endpoint.
3. Identificação do usuário.
4. Análise de processos e comandos.
5. Exportação das evidências.
6. Documentação do incidente simulado.

## 8. Conclusão

O exercício demonstrou que a combinação de Advanced Audit Policy, Event ID 4688 e PowerShell Script Block Logging fornece telemetria útil para investigação de atividades em endpoints Windows.

Em um ambiente corporativo, esses eventos poderiam ser encaminhados para uma solução SIEM para correlação e alertas centralizados.

## Evidências sugeridas

```text
screenshots/60-incident-process-evidence.png
screenshots/61-incident-powershell-evidence.png
```
