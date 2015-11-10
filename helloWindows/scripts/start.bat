@echo off
echo Create said %HELLO_MESSAGE%, now we will launch a powershell script
powershell -ExecutionPolicy ByPass -File %powershell_script%
echo Finished launching powershell script
