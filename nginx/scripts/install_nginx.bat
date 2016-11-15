C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -File  %install_nginx%
if %errorlevel% neq 0 exit /b %errorlevel%