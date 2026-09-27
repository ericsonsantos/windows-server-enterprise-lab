# 01 — Preparação do Ambiente

## Objetivo

Construir uma infraestrutura Windows corporativa virtualizada em Hyper-V, isolada da rede principal e capaz de suportar Active Directory, DNS, DHCP, File Server, GPOs e testes de segurança.

## Host

O laboratório foi executado em um computador com:

- Intel Core i3-10105
- 4 núcleos / 8 threads
- 16 GB de RAM
- Virtualização por hardware habilitada
- Hyper-V habilitado

Como o host também é utilizado para outros laboratórios, a alocação de memória das VMs foi mantida sob controle para evitar pressão excessiva sobre o sistema.

## Máquinas virtuais

### DC01

- Windows Server 2022 Standard Evaluation — Desktop Experience
- 2 vCPU
- Aproximadamente 4 GB de RAM
- IP estático: `192.168.50.10`
- Funções: AD DS, DNS, DHCP e Group Policy Management

### SRV-FILE01

- Windows Server 2022 Standard Evaluation — Desktop Experience
- IP estático: `192.168.50.20`
- Funções: File Server, SMB e permissões NTFS
- Volume de dados: `E:\Shares`

### CLIENT01

- Windows 11 Pro
- Ingressado em `corp.lab`
- Endereçamento fornecido por DHCP
- Utilizado para validar autenticação, GPOs, compartilhamentos, mapeamentos e auditoria

## Domínio

```text
FQDN: corp.lab
NetBIOS: CORP
```

Exemplo de autenticação:

```text
CORP\ericson.santos
```

## Rede virtual

Foi criado no Hyper-V um switch interno:

```text
LAB-WINDOWS
```

Rede utilizada:

```text
192.168.50.0/24
```

O host atua como gateway/NAT em:

```text
192.168.50.1
```

## Resultado

Ao final desta etapa, o laboratório possuía três VMs funcionais, uma rede virtual dedicada e conectividade externa através de NAT.

## Evidências sugeridas

```text
screenshots/02-windows-server-2022-installed.png
screenshots/03-dc01-hostname.png
screenshots/04-hyperv-lab-network.png
```
