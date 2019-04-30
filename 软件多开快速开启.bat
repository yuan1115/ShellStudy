@REM @Author: jmx
@REM @Date:   2019-04-30 16:53:59
@REM @Last Modified by:   jmx
@REM Modified time: 2019-04-30 16:54:15
@echo off
setlocal enabledelayedexpansion
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
set con=C:\bat.txt
echo 请选择操作方式:
echo ************************
echo 1.新增快捷启动
echo 2.启动快捷启动（默认）
rem echo 3.编辑快捷启动
echo ************************
set /p type=请选择：
if %type% == 1 (
    call:add
) else (
    call:open
)
pause

:isExist
	set isexist=0
	if not exist %con% goto:eof
	for /f "tokens=*" %%a in (%con%) do (
		if "%%a"=="%~1;%~2;%~3" (
			echo ----------------- 快捷启动已经存在 ---------------------
			set isexist=1
			goto:eof
		)
		for /f "delims=;, tokens=1-3" %%i in ("%%a") do ( 
			if %%j == %~2 (
				echo ------------------ 快捷启动名称已存在 --------------
				set isexist=1
				goto:eof
			)
		)
	)
	goto:eof

:filedir
	set /p file=请输入快捷启动程序路径：
	if not exist "%file%" ( 
		echo --------------- 文件不存在 ---------------------
		call:filedir
		goto:eof
	) 
	rem echo %file%
	goto:eof

:name 
	set /p name=请输入快捷启动名称：
	if "%name%" == "" (
		echo --------------- 快捷启动名称不能为空 ---------------------
		call:name
		goto:eof
	)
	rem echo %name%
	goto:eof

:timesQ
	set /p timesQ=请输入多开次数（默认1）：
	if "%timesQ%"=="" set timesQ=1
	if %timesQ% LSS 6 ( 
		if %timesQ% LSS 1 (
			set timesQ=1
		)
	) else ( set timesQ=1 )   
	rem echo %timesQ%
	goto:eof

:add
	call:filedir
	call:name
	call:timesQ
	call:isExist "!file!",!name!,!timesQ!
	if !isexist! == 0 (
		set str=!file!;!name!;!timesQ!
		echo !str!>>%con%
	)
	set /p jx=是否继续添加（y/n）：
	if "%jx%"=="y" (
		call:add
		goto:eof
	)
	goto:eof

:open
	echo 请选择快捷启动：
	set n=1
	for /f "tokens=*" %%a in (%con%) do (
		for /f "delims=;, tokens=2-3" %%i in ("%%a") do (
			echo !n!.%%i（多开次数：%%j）
		)
		set /a n+=1
	)
	set /p row=请选择:
	set m=1
	for /f "tokens=*" %%a in (%con%) do (
		if !m!==%row% (
			for /f "delims=;, tokens=1-3" %%i in ("%%a") do (
				set timesQ=%%k
				set filedir=%%i
			)
			echo !timesQ!
			set t=1
			for %%i in (1,1,!timesQ!) do (
				if !t! LEQ !timesQ! (
					start "" "!filedir!"
				)
				set /a t+=1
			)
		)
		set /a m+=1
	)
	set /p jx=是否继续添加（y/n）：
	if "%jx%"=="y" (
		call:open
		goto:eof
	)
	goto:eof
