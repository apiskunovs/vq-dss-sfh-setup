
:VIZIQUER
cmd /c setup.viziquer-dss.bat "viziquer-dss" && goto FAAS
echo Error ocurred with 'setup.viziquer-dss.bat'. Installation will end
goto End

:FAAS
cmd /c setup.SPARQLforHumans.bat "SPARQLforHumans" && goto DSS
echo Error ocurred with 'setup.SPARQLforHumans.bat'. Installation will end
goto End

:DSS
cmd /c setup.data-shape-server.bat "data-shape-server" && goto End
echo Error ocurred with 'setup.data-shape-server.bat'. Installation will end
goto End

:End
