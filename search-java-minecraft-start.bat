@echo off
Rem this programm will try to generate a start.bat with a java version between min and max if existing, otherwise ask to install

:: ---------------------------------------
:: DO NOT TOUCH ANYTHING OF THE FOLLOWING!
:: ---------------------------------------

:minIn
SET /p minIn= Enter the minimum Java Version: 
IF [%minIn%]==[] GOTO minIn
SET /a param=%minIn%+0
IF %param%==0 GOTO minIn
SET /a min=%minIn%

:maxIn
SET /p maxIn= Enter the maximum Java Version: 
IF [%maxIn%]==[] GOTO maxIn
SET /a param=%maxIn%+0
IF %param%==0 GOTO maxIn
IF NOT %maxIn% GEQ %minIn% (
echo max has to be greater or equal than min
GOTO minIn
)
SET /a max=%maxIn%

:xmsIn
SET /p xmsIn= Enter the amount of RAM (in MB) for Xms: 
IF [%xmsIn%]==[] GOTO xmsIn
SET /a param=%xmsIn%+0
IF %param%==0 GOTO xmsIn
SET /a xms=%xmsIn%

:xmxIn
SET /p xmxIn= Enter the amount of RAM (in MB) for Xmx: 
IF [%xmxIn%]==[] GOTO xmxIn
SET /a param=%xmxIn%+0
IF %param%==0 GOTO xmxIn
SET /a xmx=%xmxIn%

:jarIn
SET /p jarIn= Enter the name of your server.jar (i.E. paper.jar):
IF [%jarIn%]==[] GOTO jarIn
IF "x%jarIn:.jar=%"=="x%jarIn%" GOTO jarIn
SET jar=%jarIn%

:eulaIn
SET /p eulaIn= Do you want to automatically accept the minecraft eula? (true or false):

IF [%eulaIn%]==[] GOTO eulaIn
IF NOT [%eulaIn%]==[true] IF NOT [%eulaIn%]==[false] GOTO eulaIn
SET eula=%eulaIn%




SET currentPath=%cd%


echo.
echo  ---------------------------------
echo             Settings:
echo.
echo    jar-name: %jar%
echo    Xms: %xms%MB
echo    Xmx: %xmx%MB
IF %min% EQU %max% (
echo    java version: %min%
) ELSE (
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
IF %min% LEQ 8 (
echo.
echo  ------- WARNING -------
echo.
echo  your selected Java version is pretty outdated, if you don't need to use this version I strongly recommend using a more recent version.
echo.
echo  ------- WARNING -------
echo.
)

SET javaPath=java
FOR /f "tokens=3" %%g IN ('java -version 2^>^&1 ^| findstr /i "version"') DO (
SET JAVAVER=%%g
)
SET JAVAVER=%JAVAVER:"=%
FOR /f "delims=. tokens=1-3" %%v IN ("%JAVAVER%") DO CALL :javaVersionCheck %%v %%w %%x
GOTO End

SET javaPath=%CD:~0,3%
cd %javaPath%

:: loop through all java.exe's
FOR /f %%i IN ('dir /b /s java.exe') DO CALL :javaCheck %%i
GOTO noJavaVersion


:javaCheck
SET searchString=%1
SET key=java.exe
CALL SET keyRemoved=%%searchString:%key%=%%
:: if path contains a java.exe
IF NOT "x%keyRemoved%"=="x%searchString%" (
IF "x%searchString:$Recycle.Bin=%"=="x%searchString%" (
CALL :javaVersionTrim %searchString%
)
GOTO End
)
GOTO End


:javaVersionTrim
SET javaPath=%1
:: extract java version
FOR /f "tokens=3" %%g IN ('%1 -version 2^>^&1 ^| findstr /i "version"') DO (
SET JAVAVER=%%g
)
SET JAVAVER=%JAVAVER:"=%
FOR /f "delims=. tokens=1-3" %%v IN ("%JAVAVER%") DO CALL :javaVersionCheck %%v %%w %%x
GOTO End


:javaVersionCheck
SET /a major=%1
SET minor=%2
SET build=%3
:: check java version
IF %min% LEQ 8 (
IF %major% EQU 1 (
IF %minor% GEQ %min% (
IF %minor% LEQ %max% (
IF %minor% LEQ 8 (
echo  FOUND JAVA VERSION: %minor%
echo.
echo  Creating start.bat
echo.
CALL :createBat
GOTO End
)
GOTO End
)
GOTO End
)
GOTO End
)
GOTO End
)
IF %major% GEQ %min% (
IF %major% LEQ %max% (
echo  FOUND JAVA VERSION: %major%
echo.
echo  Creating start.bat
echo.
CALL :createBat
GOTO End
)
GOTO End
)
GOTO End


:createBat
SET content=%javaPath% -Xms%xms%M -Xmx%xmx%M -jar %jar% nogui
echo %content%>%currentPath%\start.bat
echo  start.bat created!
echo.
IF %eula% == true (
echo eula=true>%currentPath%\eula.txt
echo  eula accepted!
echo.
)
GOTO Exit


:noJavaVersion
echo  No version between Java %min% and Java %max% found.
echo.
echo  Please download it from https://adoptopenjdk.net/installation.html
echo.
GOTO Exit


:Exit
echo  Programm will exit now
echo.
PAUSE
EXIT
GOTO eof


:End
