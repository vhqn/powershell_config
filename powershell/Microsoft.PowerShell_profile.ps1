Set-Alias -Name trae -Value "D:\software\Trae CN\bin\trae-cn.cmd"
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

function touch($Path) { New-Item -ItemType File -Path $Path }
if (Test-Path Alias:rm) { Remove-Item Alias:rm -Force }
function rm($Path) { Remove-Item -Path $Path -Recurse -Force }
if (Test-Path Alias:ls) { Remove-Item Alias:ls -Force }
function ls { Get-ChildItem @args | Format-Wide -Property Name -AutoSize }
function l { Get-ChildItem @args | Sort-Object LastWriteTime }
function open($Path) { Invoke-Item -Path $Path }

if (Test-Path Alias:cd) { Remove-Item Alias:cd -Force }
function cd {
    if ($args[0] -eq '-') {
        if ($global:OLDPWD) {
            $current = (Get-Location).Path
            Set-Location $global:OLDPWD
            $global:OLDPWD = $current
        } else {
            Write-Error "cd: OLDPWD not set"
        }
    } else {
        $global:OLDPWD = (Get-Location).Path
        Set-Location @args
    }
}

# 终端选中自动复制（需要在 Trae/VS Code 设置中开启 terminal.integrated.copyOnSelection）
# Java 工具链默认使用 UTF-8 编码
$env:JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

function realpath($Path) {
    if (-not $Path) {
        $Path = "."
    }
    if (Test-Path -LiteralPath $Path) {
        (Get-Item -LiteralPath $Path).FullName
    } else {
        Write-Error "realpath: ${Path}: No such file or directory"
    }
}
