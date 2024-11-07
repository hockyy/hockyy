@echo off
if "%1"=="" goto help
if "%1"=="-h" goto help
if "%1"=="--help" goto help

if not exist "%1" (
    echo Error: File %1 not found
    goto end
)

type "%1" | clip
echo Contents of %1 copied to clipboard
goto end

:help
echo Usage: cpf filename
echo Copies the contents of a file to the clipboard
echo.
echo Options:
echo   -h, --help    Show this help message

:end