@echo off
setlocal

:: usage: SetFolderIcons [/s] [folder...]
::
:: /s switch will process subfolders. Must be the first parameter if used.

set r=0
if /i "%~1" == "/s" (
  set r=1
  shift
)
if "%~1" == "" (
  call :process "%cd%"
  goto :eof
)
:chk
if exist "%~1\" (
  call :process %1
) else (
  echo Folder "%~1" is not found or invalid.
  goto :eof
)
shift
goto chk

:process
if not exist "%~1\zFolderIcons\" goto :eof
set e=0
for %%A in ("%~1\zFolderIcons\*.ico") do (
  if exist "%~1\%%~nA\" (
    echo %~1\%%~nA
    >nul attrib -h -r -s "%~1\%%~nA\desktop.ini"
    >"%~1\%%~nA\desktop.ini" (
      echo [.ShellClassInfo]
      echo IconResource=..\zFolderIcons\%%~nA.ico,0
    )
    attrib +h +s "%~1\%%~nA\desktop.ini"
    attrib +r "%~1\%%~nA"
  )
)
if %r% == 1 (
  for /d %%A in ("%~1\*") do call :process "%%A"
)
goto :eof
pause