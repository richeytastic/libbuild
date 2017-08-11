
@echo off

if not "%PYTHON_EXE%" == "" goto :check_dev
echo No python executable set! Set PYTHON_EXE to the location of python.
goto :eof

:check_dev
if not "%DEV_PARENT_DIR%" == "" goto :check_idtf
echo The DEV_PARENT_DIR environment variable is not set!
goto :eof

:check_idtf
if not "%IDTF_CONVERTER_EXE%" == "" goto :check_pdflatex
echo IDTFConverter.exe not set! Won't be able to convert to U3D format (rModelIO).

:check_pdflatex
if not "%PDFLATEX_EXE%" == "" goto :exec
echo pdflatex.exe not set! Won't be able to generate PDFs (rModelIO).


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
