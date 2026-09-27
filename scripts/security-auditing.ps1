<#
.SYNOPSIS
    Validação e coleta de evidências de segurança do laboratório.

.DESCRIPTION
    O script NÃO cria ataques nem executa ações ofensivas.
    Ele valida auditoria e exporta eventos já existentes.
#>

$EvidencePath = "C:\Lab-Evidence"
New-Item -ItemType Directory -Path $EvidencePath -Force | Out-Null

Write-Host "Política efetiva de senha do domínio:"
Get-ADDefaultDomainPasswordPolicy |
    Format-List MinPasswordLength,
                PasswordHistoryCount,
                ComplexityEnabled,
                MaxPasswordAge,
                MinPasswordAge,
                LockoutThreshold,
                LockoutDuration,
                LockoutObservationWindow

Write-Host "Auditoria de criação de processos:"
auditpol /get /subcategory:"Process Creation"

Write-Host "Auditoria de logon:"
auditpol /get /subcategory:"Logon"

Write-Host "Auditoria de validação de credenciais:"
auditpol /get /subcategory:"Credential Validation"

$SecurityEventIds = 4625,4688,4720,4726,4728,4729,4740,4776

Get-WinEvent -FilterHashtable @{
    LogName = "Security"
    Id      = $SecurityEventIds
} -ErrorAction SilentlyContinue |
Select-Object TimeCreated,Id,MachineName,Message |
Export-Csv `
    -Path "$EvidencePath\Security-Events.csv" `
    -NoTypeInformation `
    -Encoding UTF8

Get-WinEvent `
    -LogName "Microsoft-Windows-PowerShell/Operational" `
    -ErrorAction SilentlyContinue |
Where-Object Id -eq 4104 |
Select-Object TimeCreated,Id,MachineName,Message |
Export-Csv `
    -Path "$EvidencePath\PowerShell-4104.csv" `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host "Evidências exportadas para $EvidencePath"
Get-ChildItem $EvidencePath
