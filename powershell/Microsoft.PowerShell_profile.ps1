Set-Alias -Name trae -Value "D:\software\Trae CN\bin\trae-cn.cmd"

function touch($Path) { New-Item -ItemType File -Path $Path }
if (Test-Path Alias:rm) { Remove-Item Alias:rm -Force }
function rm($Path) { Remove-Item -Path $Path -Recurse -Force }
