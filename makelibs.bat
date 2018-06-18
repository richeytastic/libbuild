
@echo off

:check_dev
if not "%DEV_PARENT_DIR%" == "" goto :exec
echo The DEV_PARENT_DIR environment variable is not set!
goto :eof

:exec

setlocal

set _python="python.exe"
set _makelibs="%DEV_PARENT_DIR%\libbuild\makelibs.py"

call %_python% %_makelibs% %1 %2 %3
goto :eof

endlocal

:eof
