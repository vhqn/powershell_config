# install.ps1 — 将 powershell/ 配置文件链接到 Windows 上的 PowerShell 配置目录
# 需要管理员权限运行，或者在 Windows 设置中开启开发者模式（允许创建符号链接）

param()

$ErrorActionPreference = "Stop"

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SrcProfile = Join-Path $DotfilesDir "powershell\Microsoft.PowerShell_profile.ps1"
$DstProfile = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

function Link-File {
    param([string]$Src, [string]$Dst)

    $Dir = Split-Path -Parent $Dst

    if (-not (Test-Path $Dir)) {
        Write-Host "  Creating directory: $Dir"
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }

    $item = Get-Item $Dst -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -ne "SymbolicLink") {
        Write-Host "  [backup] $Dst -> $Dst.bak"
        Move-Item $Dst "$Dst.bak" -Force
    }

    New-Item -ItemType SymbolicLink -Path $Dst -Target $Src -Force | Out-Null
    Write-Host "  [linked] $Dst"
}

Write-Host "==> Linking PowerShell profile ..."
Link-File -Src $SrcProfile -Dst $DstProfile

Write-Host ""
Write-Host "Done! Restart PowerShell for changes to take effect."
