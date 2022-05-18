@echo off
setlocal
prompt $g 

:: passed parameters
set "folder=%1"
set "curdir=%cd%"
if "%folder%" == """" goto :ErrorUsage 
if "%folder%" == "" goto :ErrorUsage 

echo ********************************************************************
echo * %~nx0 started...
echo ********************************************************************

:: verify commands
:VerifyFolder
if exist "%folder%\" (
  echo "%folder%" exists. Remove it and press any key to continue
  pause >nul
  goto :VerifyFolder
)

:VerifyCmd1
echo npm version: 
cmd /c npm --version && goto :VerifyCmd2
echo command 'npm --version' failed. Verify command is installed correctly and press any key to continue...
pause >nul
goto :VerifyCmd1

:VerifyCmd2
echo git version: 
cmd /c git --version && goto :Main
echo command 'git --version' failed. Verify command is installed correctly and press any key to continue...
pause >nul
goto :VerifyCmd2

:Main
:: clone to new folder
echo ====================================================================
echo Git cloning...
echo ====================================================================
git clone https://github.com/LUMII-Syslab/viziquer.git %folder%
cd %folder%
git switch instance-autocompletion
git pull

:: copy additions
echo ====================================================================
echo Copying additions...
echo ====================================================================
set fndir=..\additions\files\viziquer-dss\
if exist %fndir% (
	xcopy %fndir%* . /E /H /C /I /Y
) else (
	echo "Nothing to copy"
)

:: extracting additions
echo ====================================================================
echo extracting additions...
echo ====================================================================
set zipdir=..\additions\archives\viziquer-dss\
if exist %zipdir% (
	for %%a in (%zipdir%*.zip) do (
		powershell Expand-Archive "%%a" -DestinationPath .
	)
) else (
	echo "Nothing to extract"
)

:: Install all dependencies
echo ====================================================================
echo npm install...
echo ====================================================================
cmd /C npm install
goto :End


:ErrorUsage
echo Usage: %~nx0 [folder name]
goto :End

:End
cd "%curdir%"
endlocal
prompt
@echo on
