@echo off
rem Runs verify-set.ps1, preferring PowerShell 7 and falling back to Windows PowerShell 5.1.
rem -ExecutionPolicy Bypass applies to this process only; nothing system-wide changes.
setlocal
set "PS=powershell"
where pwsh >nul 2>nul
if not errorlevel 1 set "PS=pwsh"
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0verify-set.ps1" %*
exit /b %ERRORLEVEL%
