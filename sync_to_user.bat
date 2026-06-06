@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo   WezTerm Config Sync Tool
echo ========================================
echo.

set SOURCE=F:\learn-front\learn_cmd\wezterm
set TARGET=C:\Users\Administrator\.config\wezterm

echo Source: %SOURCE%
echo Target: %TARGET%
echo.

REM Check if target directory exists
if not exist "%TARGET%" (
    echo [Creating] Target directory...
    mkdir "%TARGET%"
    echo [OK] Directory created
    echo.
)

echo Syncing files...
echo.

REM Copy all files and subdirectories (exclude .idea and .git)
robocopy "%SOURCE%" "%TARGET%" /E /XF .gitignore /XD .idea .git /NFL /NDL /NJH /NJS

echo.
echo ========================================
echo   Sync Complete!
echo ========================================
echo.
echo Synced files:
echo   - wezterm.lua
echo   - config/ (all configs)
echo   - events/ (all event handlers)
echo   - utils/ (all utility scripts)
echo   - colors/ (color themes)
echo   - CONFIG_GUIDE.md
echo   - TOOLS_GUIDE.md
echo   - README.md
echo.
echo Tip: Restart WezTerm to apply new config
echo.
pause
