@echo off
if "%~1"=="" (
    dir /b
) else (
    dir /b "%~1"
)