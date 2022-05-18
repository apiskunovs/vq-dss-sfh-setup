@echo off
setlocal
prompt $g 

:: passed parameters
set "folder=%1"
set "curdir=%cd%"
if "%folder%" == """" goto ErrorUsage 
if "%folder%" == "" goto ErrorUsage 

echo ********************************************************************
echo * %~nx0 started...
echo ********************************************************************

:: verify commands
:VerifyFolder
if exist "%folder%\" (
  echo "%folder%" exists. Remove it and press any key to continue
  pause >nul
  goto VerifyFolder
)

:VerifyCmd1
echo dotnet version: 
cmd /c dotnet --version && goto VerifyCmd2
echo command 'dotnet --version' failed. Verify command is installed correctly and press any key to continue...
pause >nul
goto VerifyCmd1

:VerifyCmd2
echo git version: 
cmd /c git --version && goto Main
echo command 'git --version' failed. Verify command is installed correctly and press any key to continue...
pause >nul
goto VerifyCmd2

:Main
:: clone to new folder
echo ====================================================================
echo Git cloning...
echo ====================================================================
git clone https://github.com/apiskunovs/SPARQLforHumans.git %folder%
cd %folder%
git switch feature/instance-autocompletion
git pull

:: copy additions
echo ====================================================================
echo Copying additions...
echo ====================================================================
set fndir=..\additions\files\SPARQLforHumans\
if exist %fndir% (
	xcopy %fndir%* . /E /H /C /I /Y
) else (
	echo "Nothing to copy"
)

:: extracting additions
echo ====================================================================
echo extracting additions...
echo ====================================================================
set zipdir=..\additions\archives\SPARQLforHumans\
if exist %zipdir% (
	for %%a in (%zipdir%*.zip) do (
		powershell Expand-Archive "%%a" -DestinationPath .
	)
) else (
	echo "Nothing to extract"
)

:: Install all dependencies
echo ====================================================================
echo dotnet build...
echo ====================================================================
cmd /C dotnet build
goto End

:ErrorUsage
echo Usage: %~nx0 [folder name]
goto End

:End
cd "%curdir%"
endlocal
prompt
@echo on
