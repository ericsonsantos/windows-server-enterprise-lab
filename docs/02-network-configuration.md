# 02 — Configuração de Rede

## Objetivo

Criar uma rede virtual previsível e isolada para o laboratório, permitindo comunicação entre servidores e clientes, resolução DNS interna e acesso externo por NAT.

## Topologia

```text
Internet
   |
Host Hyper-V
192.168.50.1
   |
LAB-WINDOWS
   |
   +-- DC01        192.168.50.10
   +-- SRV-FILE01  192.168.50.20
   +-- CLIENT01    DHCP
```

## vSwitch

Switch interno criado no Hyper-V:

```text
LAB-WINDOWS
```

## Endereçamento

| Host | IP | Gateway | DNS |
|---|---|---|---|
| DC01 | `192.168.50.10/24` | `192.168.50.1` | `192.168.50.10` |
| SRV-FILE01 | `192.168.50.20/24` | `192.168.50.1` | `192.168.50.10` |
| CLIENT01 | DHCP | `192.168.50.1` | `192.168.50.10` |

## NAT no host

Exemplo de configuração utilizada:

```powershell
New-NetIPAddress `
  -InterfaceAlias "vEthernet (LAB-WINDOWS)" `
  -IPAddress 192.168.50.1 `
  -PrefixLength 24

New-NetNat `
  -Name "LAB-WINDOWS-NAT" `
  -InternalIPInterfaceAddressPrefix "192.168.50.0/24"
```

Validação:

```powershell
Get-NetNat
Get-NetIPAddress -InterfaceAlias "vEthernet (LAB-WINDOWS)"
```

## Testes

No DC01 e demais VMs:

```powershell
ping 192.168.50.1
ping 192.168.50.10
Resolve-DnsName dc01.corp.lab
```

## Troubleshooting realizado

Durante a configuração, o gateway virtual respondia de forma inconsistente a ICMP porque o firewall do host não permitia o tráfego esperado. Foi criada uma regra de entrada para ICMP no host, restrita à rede do laboratório `192.168.50.0/24`.

Esse ponto foi importante para diferenciar:

- conectividade IP;
- comportamento do firewall;
- comunicação entre host e VMs;
- funcionamento do NAT.

## Evidências sugeridas

```text
screenshots/04-hyperv-lab-network.png
screenshots/05-dc01-static-ip.png
screenshots/06-dc01-connectivity-tests.png
```
