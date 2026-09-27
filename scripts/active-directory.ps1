<#
.SYNOPSIS
    Criação de OUs, grupos e usuários para o laboratório corp.lab.

.DESCRIPTION
    Script educacional. Revise antes de executar.
    Requer módulo ActiveDirectory e privilégios apropriados.
#>

Import-Module ActiveDirectory

$DomainDN = "DC=corp,DC=lab"

$OUs = @(
    "TI",
    "Financeiro",
    "RH",
    "Comercial",
    "Operacoes",
    "Servidores",
    "Computadores"
)

foreach ($OU in $OUs) {
    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$OU)" -SearchBase $DomainDN -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $OU -Path $DomainDN -ProtectedFromAccidentalDeletion $true
        Write-Host "OU criada: $OU"
    }
}

$GlobalGroups = @(
    @{ Name="GG_TI"; OU="TI" },
    @{ Name="GG_FINANCEIRO"; OU="Financeiro" },
    @{ Name="GG_RH"; OU="RH" },
    @{ Name="GG_COMERCIAL"; OU="Comercial" },
    @{ Name="GG_OPERACOES"; OU="Operacoes" }
)

foreach ($Group in $GlobalGroups) {
    if (-not (Get-ADGroup -Filter "SamAccountName -eq '$($Group.Name)'" -ErrorAction SilentlyContinue)) {
        New-ADGroup `
            -Name $Group.Name `
            -SamAccountName $Group.Name `
            -GroupScope Global `
            -GroupCategory Security `
            -Path "OU=$($Group.OU),$DomainDN"
    }
}

$DomainLocalGroups = @(
    "DL_TI_RW",
    "DL_FINANCEIRO_RW",
    "DL_RH_RW",
    "DL_COMERCIAL_RW",
    "DL_OPERACOES_RW"
)

foreach ($Group in $DomainLocalGroups) {
    if (-not (Get-ADGroup -Filter "SamAccountName -eq '$Group'" -ErrorAction SilentlyContinue)) {
        New-ADGroup `
            -Name $Group `
            -SamAccountName $Group `
            -GroupScope DomainLocal `
            -GroupCategory Security `
            -Path "OU=Servidores,$DomainDN"
    }
}

$Password = Read-Host "Digite a senha inicial dos usuários" -AsSecureString

$Users = @(
    @{ Name="Ericson Santos"; Sam="ericson.santos"; OU="TI"; Group="GG_TI" },
    @{ Name="Ana Silva"; Sam="ana.silva"; OU="Financeiro"; Group="GG_FINANCEIRO" },
    @{ Name="Mariana Costa"; Sam="mariana.costa"; OU="RH"; Group="GG_RH" },
    @{ Name="Carlos Souza"; Sam="carlos.souza"; OU="Comercial"; Group="GG_COMERCIAL" },
    @{ Name="Lucas Oliveira"; Sam="lucas.oliveira"; OU="Operacoes"; Group="GG_OPERACOES" }
)

foreach ($User in $Users) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($User.Sam)'" -ErrorAction SilentlyContinue)) {
        New-ADUser `
            -Name $User.Name `
            -SamAccountName $User.Sam `
            -UserPrincipalName "$($User.Sam)@corp.lab" `
            -Path "OU=$($User.OU),$DomainDN" `
            -AccountPassword $Password `
            -Enabled $true `
            -ChangePasswordAtLogon $true
    }

    Add-ADGroupMember -Identity $User.Group -Members $User.Sam -ErrorAction SilentlyContinue
}

$Nesting = @{
    "DL_TI_RW"          = "GG_TI"
    "DL_FINANCEIRO_RW" = "GG_FINANCEIRO"
    "DL_RH_RW"          = "GG_RH"
    "DL_COMERCIAL_RW"   = "GG_COMERCIAL"
    "DL_OPERACOES_RW"   = "GG_OPERACOES"
}

foreach ($DL in $Nesting.Keys) {
    Add-ADGroupMember -Identity $DL -Members $Nesting[$DL] -ErrorAction SilentlyContinue
}

Write-Host "Configuração base do Active Directory concluída."
