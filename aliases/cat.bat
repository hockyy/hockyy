@echo off
if "%1"=="" goto help
if "%1"=="-h" goto help
if "%1"=="--help" goto help

:loop
if "%1"=="" goto end
if not exist "%1" (
    echo Error: %1: No such file
    shift
    goto loop
)
type "%1"
shift
goto loop

:help
echo Usage: cat [file...]
echo Display the contents of one or more files
echo.
echo Options:
echo   -h, --help    Show this help message

:end