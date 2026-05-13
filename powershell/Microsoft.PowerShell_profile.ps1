Set-Alias -Name trae -Value "D:\software\Trae CN\bin\trae-cn.cmd"

function touch($Path) { New-Item -ItemType File -Path $Path }
if (Test-Path Alias:rm) { Remove-Item Alias:rm -Force }
function rm($Path) { Remove-Item -Path $Path -Recurse -Force }
function l { Get-ChildItem @args | Sort-Object LastWriteTime }

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
