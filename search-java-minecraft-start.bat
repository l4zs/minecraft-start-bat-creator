@echo off
Rem this programm will try to generate a start.bat with a java version between min and max if existing, otherwise ask to install

:: ---------------------------------------
:: DO NOT TOUCH ANYTHING OF THE FOLLOWING!
:: ---------------------------------------

:minIn
set /p minIn= Enter the minimum Java Version: 
if [%minIn%]==[] goto minIn
SET /a param=%minIn%+0
IF %param%==0 goto minIn
set /a min=%minIn%

:maxIn
set /p maxIn= Enter the maximum Java Version: 
if [%maxIn%]==[] goto maxIn
SET /a param=%maxIn%+0
IF %param%==0 goto maxIn
set /a max=%maxIn%

:xmsIn
set /p xmsIn= Enter the amount of RAM (in MB) for Xms: 
if [%xmsIn%]==[] goto xmsIn
SET /a param=%xmsIn%+0
IF %param%==0 goto xmsIn
set /a xms=%xmsIn%

:xmxIn
set /p xmxIn= Enter the amount of RAM (in MB) for Xmx: 
if [%xmxIn%]==[] goto xmxIn
SET /a param=%xmxIn%+0
IF %param%==0 goto xmxIn
set /a xmx=%xmxIn%

:jarIn
set /p jarIn= Enter the name of your server.jar (i.E. paper.jar):
if [%jarIn%]==[] goto jarIn
IF "x%jarIn:.jar=%"=="x%jarIn%" goto jarIn
set jar=%jarIn%

:eulaIn
set /p eulaIn= Do you want to automatically accept the minecraft eula? (true or false):
if [%eulaIn%]==[] goto eulaIn
if not [%eulaIn%]==[true] if not [%eulaIn%]==[false] goto eulaIn
set eula=%eulaIn%



set currentPath=%cd%
set javaPath=%CD:~0,3%
echo.
echo  ---------------------------------
echo             Settings:
echo.
echo    jar-name: %jar%
echo    Xms: %xms%MB
echo    Xmx: %xmx%MB
if %min% EQU %max% (
echo    java version: %min%
) else (
echo    java version between %min% and %max%
)
echo    auto-accept eula: %eula%
echo  ---------------------------------
echo.
echo    created by:
echo    l4zs
echo.
echo  ---------------------------------
echo    Searching for java versions..
echo    this may take several minutes
echo  ---------------------------------
echo.
if %min% LEQ 8 (
echo.
echo  ------- WARNING -------
echo.
echo  your selected Java version is pretty outdated, if you don't need to use this version I strongly recommend using a more recent version.
echo.
echo  ------- WARNING -------
echo.
)
cd %javaPath%
:: loop through all java.exe's
for /f %%i in ('dir /b /s java.exe') do call :javaCheck %%i
goto noJavaVersion


:javaCheck
SET searchString=%1
SET key=java.exe
call SET keyRemoved=%%searchString:%key%=%%
:: if path contains a java.exe
IF NOT "x%keyRemoved%"=="x%searchString%" (
IF "x%searchString:$Recycle.Bin=%"=="x%searchString%" (
call :javaVersionTrim %searchString%
)
goto End
)
goto End


:javaVersionTrim
set javaPath=%1
:: extract java version
for /f "tokens=3" %%g in ('%1 -version 2^>^&1 ^| findstr /i "version"') do (
set JAVAVER=%%g
)
set JAVAVER=%JAVAVER:"=%
for /f "delims=. tokens=1-3" %%v in ("%JAVAVER%") do call :javaVersionCheck %%v %%w %%x
goto End


:javaVersionCheck
set /a major=%1
set minor=%2
set build=%3
:: check java version
if %min% LEQ 8 (
if %major% EQU 1 (
if %minor% GEQ %min% (
if %minor% LEQ %max% (
if %minor% LEQ 8 (
echo  FOUND JAVA VERSION: %minor%
echo.
echo  Creating start.bat
echo.
call :createBat
goto End
)
goto End
)
goto End
)
goto End
)
goto End
)
if %major% GEQ %min% (
if %major% LEQ %max% (
echo  FOUND JAVA VERSION: %major%
echo.
echo  Creating start.bat
echo.
call :createBat
goto End
)
goto End
)
goto End


:createBat
set content=%javaPath% -Xms%xms%M -Xmx%xmx%M -jar %jar% nogui
echo %content%>%currentPath%\start.bat
echo  start.bat created!
echo.
if %eula% == true (
echo eula=true>%currentPath%\eula.txt
echo  eula accepted!
echo.
)
goto Exit


:noJavaVersion
echo  No version between Java %min% and Java %max% found.
echo.
echo  Please download it from https://adoptopenjdk.net/installation.html
echo.
goto Exit


:Exit
echo  Programm will exit now
echo.
pause
exit
goto eof


:End
