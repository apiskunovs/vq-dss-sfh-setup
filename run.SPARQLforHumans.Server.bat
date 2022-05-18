@echo off
:: passed parameters
set "folder=%1"
if "%folder%" == """" goto ErrorUsage 
if "%folder%" == "" goto ErrorUsage 

@echo on

cd "%folder%"
dotnet build .
cd SparqlForHumans.Server
dotnet run

goto End


:ErrorUsage
echo Usage: %~nx0 [folder name]

:End