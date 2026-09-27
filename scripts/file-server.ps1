<#
.SYNOPSIS
    Criação de pastas, permissões NTFS e compartilhamentos SMB departamentais.

.DESCRIPTION
    Executar no SRV-FILE01 como Administrador.
    Requer que os grupos Domain Local já existam no domínio.
#>

$BasePath = "E:\Shares"
$Admins = (Get-LocalGroup -SID "S-1-5-32-544").Name

$Departments = @(
    @{ Name="TI";          Group="CORP\DL_TI_RW" },
    @{ Name="Financeiro";  Group="CORP\DL_FINANCEIRO_RW" },
    @{ Name="RH";          Group="CORP\DL_RH_RW" },
    @{ Name="Comercial";   Group="CORP\DL_COMERCIAL_RW" },
    @{ Name="Operacoes";   Group="CORP\DL_OPERACOES_RW" }
)

New-Item -ItemType Directory -Path $BasePath -Force | Out-Null

foreach ($Department in $Departments) {
    $Path = Join-Path $BasePath $Department.Name

    New-Item -ItemType Directory -Path $Path -Force | Out-Null

    icacls $Path /inheritance:r | Out-Null
    icacls $Path /grant "${Admins}:(OI)(CI)F" | Out-Null
    icacls $Path /grant "SYSTEM:(OI)(CI)F" | Out-Null
    icacls $Path /grant "$($Department.Group):(OI)(CI)M" | Out-Null

    if (-not (Get-SmbShare -Name $Department.Name -ErrorAction SilentlyContinue)) {
        New-SmbShare `
            -Name $Department.Name `
            -Path $Path `
            -ChangeAccess $Department.Group | Out-Null
    }
}

Get-SmbShare |
    Where-Object Name -in $Departments.Name |
    Select-Object Name,Path
