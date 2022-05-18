prompt $g 

:VERIFY_NPM
@call :fnPrintHeader "npm verification..."
cmd /c npm --version && goto VERIFY_GIT
goto ERROR_BLOCK

:VERIFY_GIT
@call :fnPrintHeader "git verification..."
cmd /c git --version && goto VERIFY_XCOPY
goto ERROR_BLOCK

:VERIFY_XCOPY
@call :fnPrintHeader "xcopy verification..."
cmd /c help xcopy | findstr /B "Copies files" && goto VERIFY_DOTNET
goto ERROR_BLOCK

:VERIFY_DOTNET
@call :fnPrintHeader "dotnet verification..."
cmd /c dotnet --version && goto VERIFY_EXPAND_ARCHIVE
goto ERROR_BLOCK

:VERIFY_EXPAND_ARCHIVE
@call :fnPrintHeader "Expand-Archive verification..."
cmd /c powershell Get-Help Expand-Archive && goto VERIFY_FINAL
goto ERROR_BLOCK

:VERIFY_FINAL
@call :fnPrintHeader "Check successful!"
@goto END

:fnPrintHeader
@echo.
@echo.
@echo =====================================================================
@echo %~1
@echo ===================================================================== && @EXIT /B 0

:ERROR_BLOCK
@call :fnPrintHeader "Check the log! Some verification commands failed. Install prerequsites and check requirements again."

:END
@prompt
