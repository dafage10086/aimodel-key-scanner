@echo off
setlocal
cd /d "%~dp0"
set "PY=.venv\Scripts\python.exe"
if not exist "%PY%" (
  where python >nul 2>nul || (echo Python was not found in PATH. & exit /b 1)
  echo Creating local virtual environment...
  python -m venv .venv
  if errorlevel 1 exit /b 1
)
echo Checking Python dependencies...
"%PY%" -m pip install --disable-pip-version-check -q -r requirements.txt
if errorlevel 1 exit /b 1
if /I "%~1"=="--self-test" (
  "%PY%" github_key_scanner.py --help >nul
  if errorlevel 1 exit /b 1
  exit /b 0
)
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TS=%%i"
set "OUT=results\run_%TS%"
mkdir "%OUT%" >nul 2>nul
echo [GitHub AI Key Scanner]
echo Output folder: %CD%\%OUT%
echo Running zero-token public scan. Close this window to stop.
echo.
"%PY%" github_key_scanner.py --output "%OUT%"
set "CODE=%ERRORLEVEL%"
echo.
echo Finished with exit code %CODE%.
echo Press any key to close this window.
pause >nul
exit /b %CODE%