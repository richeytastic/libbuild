@echo off

setlocal

set _python="python.exe"
set _makelibs="%~dp0%makelibs.py"

call %_python% %_makelibs% %1 %2 %3 %4 %5 %6 %7 %8
goto :eof

endlocal

:eof
