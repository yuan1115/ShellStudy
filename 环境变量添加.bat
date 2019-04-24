@REM @Author: jmx
@REM @Date:   2019-04-24 10:12:39
@REM @Last Modified by:   jmx
@REM Modified time: 2019-04-24 16:20:33
@echo off
rem Switching Administrator Mode
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit

set /p var=Please select the type of environment variables (1. System environment variables; 2. User environment variables):
echo *****************
if defined var (
	if %var%==1 (
		set regpath=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
		set type=REG_EXPAND_SZ
		echo Selection of system environment variables 
	) else (
		set regpath=HKCU\Environment
		set type=REG_SZ
		echo Selection of user environment variables
	)
) else (
	set regpath=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
	set type=REG_EXPAND_SZ
	echo Selection of system environment variables 
)
for /f "tokens=1,2,* " %%i in ('REG QUERY "%regpath%" /v Path ^| find /i "Path"') do (set opath=%%k)
echo *****************
set /p addpath=Enter the environment variables you need to add:
echo %addpath%
if defined addpath (
	REG ADD "%regpath%" /v Path /t %type% /d "%opath%%addpath%;" /f
	echo The new environmental variables are:%opath%%addpath%£»
) else (
	echo Environment variables that need to be added cannot be null
)
pause