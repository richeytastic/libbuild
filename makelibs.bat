
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

REM Make all the libraries if nothing specified.
if "%1" == "" goto :make_all
set _lib=%1
call %_python% %_makelibs% %_lib%
goto :eof

:make_all
call %_python% %_makelibs% all debug
goto :eof

endlocal

:eof
