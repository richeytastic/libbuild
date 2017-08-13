
@echo off

if not "%PYTHON_EXE%" == "" goto :check_dev
echo No python executable set! Set PYTHON_EXE to the location of python.
goto :eof

:check_dev
if not "%DEV_PARENT_DIR%" == "" goto :exec
echo The DEV_PARENT_DIR environment variable is not set!
goto :eof

:exec

setlocal

set _python="%PYTHON_EXE%"
set _makelibs="%DEV_PARENT_DIR%\libbuild\makelibs.py"
set _lib=%1
set _debug=%2

call %_python% %_makelibs% %_lib% %_debug%
goto :eof

endlocal

:eof
