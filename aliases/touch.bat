@echo off
if "%1"=="" (
    echo Usage: touch filename
    echo Creates a new empty file or updates timestamp of existing file
    goto :eof
)

if exist %1 (
    copy /b %1 +,, > nul
) else (
    type nul > %1
)