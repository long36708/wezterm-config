@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo   Nushell Config Sync Tool
echo ========================================
echo.

set SOURCE=F:\learn-front\learn_cmd\wezterm\nushell
set TARGET=C:\Users\Administrator\AppData\Roaming\nushell

echo Source: %SOURCE%
echo Target: %TARGET%
echo.

REM Step 1: Add claude completions to config.nu if not exists
echo [Step 1] Checking config.nu for claude completions...
findstr /C:"custom-completions/claude/claude-completions.nu" "%SOURCE%\config.nu" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Adding claude completions to config.nu...
    
    REM Use PowerShell to insert the line after git completions
    powershell -Command "$content = Get-Content '%SOURCE%\config.nu' -Encoding UTF8; $newLine = 'use ~/AppData/Roaming/nushell/custom-completions/claude/claude-completions.nu *'; $index = $content.IndexOf('use ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu *'); if ($index -ge 0) { $content = $content[0..$index] + $newLine + $content[($index+1)..($content.Length-1)]; $content | Set-Content '%SOURCE%\config.nu' -Encoding UTF8; Write-Host '[OK] Added claude completions line' } else { Write-Host '[WARN] Could not find git completions line' }"
) else (
    echo [OK] Claude completions already in config.nu
)
echo.

REM Check if target directory exists
if not exist "%TARGET%" (
    echo [Creating] Target directory...
    mkdir "%TARGET%"
    echo [OK] Directory created
    echo.
)

REM Check if custom-completions directory exists in target
if not exist "%TARGET%\custom-completions" (
    echo [Creating] custom-completions directory...
    mkdir "%TARGET%\custom-completions"
    echo [OK] Directory created
    echo.
)

echo [Step 2] Syncing custom completions...
echo.

REM Copy claude completions
if exist "%SOURCE%\custom-completions\claude" (
    robocopy "%SOURCE%\custom-completions\claude" "%TARGET%\custom-completions\claude" /E /NFL /NDL /NJH /NJS
    echo [OK] Claude completions synced
) else (
    echo [WARN] Claude completions not found
)

REM Copy git completions
if exist "%SOURCE%\custom-completions\git" (
    robocopy "%SOURCE%\custom-completions\git" "%TARGET%\custom-completions\git" /E /NFL /NDL /NJH /NJS
    echo [OK] Git completions synced
) else (
    echo [WARN] Git completions not found
)

echo.
echo [Step 3] Syncing config.nu...
echo.

REM Copy config.nu to target
if exist "%SOURCE%\config.nu" (
    copy /Y "%SOURCE%\config.nu" "%TARGET%\config.nu" >nul
    echo [OK] config.nu synced
) else (
    echo [ERROR] config.nu not found in source
)

echo.
echo ========================================
echo   Sync Complete!
echo ========================================
echo.
echo Synced files:
echo   - config.nu (with claude completions enabled)
echo   - custom-completions/claude/
echo   - custom-completions/git/
echo.
echo Tip: Restart Nushell or run 'source-env $env.NU_LIB_DIRS.0/config.nu'
echo.
pause
