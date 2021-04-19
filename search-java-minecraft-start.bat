@echo off
Rem this programm will try to generate a start.bat with a java version between min and max if existing, otherwise ask to install

:: --------------
:: CONFIGURE HERE
:: --------------

:: automatically accept eula
set eula=true

:: change this to the name of your server.jar i.E. paper.jar
set jar=paper.jar

:: specify the ram usage in MB here:
set /a xmx=2048
set /a xms=2048

:: change this to specified java min / max version
set /a min=11
set /a max=15



:: ---------------------------------------
:: DO NOT TOUCH ANYTHING OF THE FOLLOWING!
:: ---------------------------------------



set currentPath=%cd%
set javaPath=%CD:~0,3%
echo.
echo ---------------------------------
echo              Values:
echo.
echo   jar-name: %jar%
echo   xms: %xms%
echo   xmx: %xmx%
if min == max (
echo   java version: %min%
) else (
echo   java version between %min% and %max%
)
echo ---------------------------------
echo.
echo   created by:
echo   l4zs
echo.
echo ---------------------------------
echo   Searching for java versions..
echo   this may take several minutes
echo ---------------------------------
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
call :javaVersionTrim %searchString%
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
if %major% GEQ %min% (
if %major% LEQ %max% (
echo FOUND JAVA VERSION: %major%
echo.
echo Creating start.bat
echo.
call :createBat
)
goto End
)
goto End


:createBat
set content=%javaPath% -Xms%xms%M -Xmx%xmx%M -jar %jar% nogui
echo %content%>%currentPath%\start.bat
echo start.bat created!
if %eula% == true (
echo eula=true>%currentPath%\eula.txt
echo eula accepted!
)
echo Programm will exit now
pause
goto Exit


:noJavaVersion
echo No Java is installed or there is no Version between Java %min% and Java %max%
echo Please download it from https://adoptopenjdk.net/installation.html
echo Programm will exit now
pause
goto Exit


:Exit
exit
goto eof


:End