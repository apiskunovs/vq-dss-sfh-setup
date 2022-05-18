@echo off

:CHECKING_PORTS
set ports=3000 3344 59286
call :fnPrintHeader "Checking ports %ports%"
for /f %%i in ('netstat -aon ^| findstr "%ports%" ^| find /v /c ""') do set RESULT=%%i
if NOT %RESULT%==0 (
	echo ================================================================================
	echo Some of required ports are still in use. Stop running services on those ports 
	echo and run this script again. You may use KILLTASK [pid]
	echo ================================================================================
	netstat -aon | findstr "%ports%"
	goto END
)
echo All ports are free to use.

:STARTING_UP
call :fnPrintHeader "Starting services up"

echo on

start cmd /k run.viziquer-dss.bat "viziquer-dss"
start cmd /k run.SPARQLforHumans.Server.bat "SPARQLforHumans"
start cmd /k run.data-shape-server.Server.bat "data-shape-server"

@echo ViziQuer will start soon...
@cmd /c timeout 15 && explorer http://localhost:3000/
@goto END

:fnPrintHeader
@echo.
@echo.
@echo =====================================================================
@echo %~1
@echo ===================================================================== && @EXIT /B 0

:END

