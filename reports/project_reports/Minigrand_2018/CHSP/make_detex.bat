SETLOCAL
set original="CHSP.tex"
set output="E:\Publikacje\Grammarly-LaTeX-man\grammarly_web\detex-out.txt"
::set output="\\tsclient\E\grammarly_web\detex-out.txt"
set detex="E:\Publikacje\Grammarly-LaTeX-man\opendetex\detex.exe"
::set detex=%~dp0\..\..\..\bin\external\opendetex\detex.exe
%detex% -l %original%>%output%
ENDLOCAL
