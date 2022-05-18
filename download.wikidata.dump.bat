@echo off
set url=https://dumps.wikimedia.org/wikidatawiki/entities/latest-truthy.nt.gz
set gzip=.\data\wikidata\latest-truthy.nt.gz
set destFolder=%userprofile%\SparqlForHumans\Wikidata


:VerifyCmd1
echo Check curl version: 
cmd /c curl --version && goto VerifyFile
echo command 'curl --version' failed. Verify command is installed correctly and press any key to continue...
pause >nul
goto VerifyCmd1

:VerifyFile
if exist "%gzip%" (
  echo File "%gzip%" must be deleted before downloading new one. Delete it and press any key to continue...
  pause >nul
  goto VerifyFile
)

:Main
echo on
curl.exe "%url%" -o %gzip% --create-dirs && echo Download ok

