Set-Alias -Name tr -Value "D:\software\Trae CN\bin\trae-cn.cmd"
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Key Ctrl+k -ScriptBlock {
    Clear-Host
}

function touch($Path) { New-Item -ItemType File -Path $Path }
if (Test-Path Alias:rm) { Remove-Item Alias:rm -Force }
function rm($Path) {
    if ($Path -match '[\*\?\[\]]') {
        # 含通配符，使用 -Path 来展开通配符
        Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
    } else {
        # 不含通配符，走原来的逻辑（支持 cmd 兜底处理长路径等顽固文件）
        Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path -LiteralPath $Path) {
            cmd /c rd /s /q "$Path" 2>$null
        }
    }
}
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
# $env:JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

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

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
