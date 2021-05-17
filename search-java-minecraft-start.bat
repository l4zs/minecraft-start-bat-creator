@echo off
Rem this programm will try to generate a start.bat with a java version between min and max if existing, otherwise ask to install

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

:ramIn
SET /p ramIn= Do you want to set the ram usage (true or false):
IF [%ramIn%]==[] GOTO ramIn
IF NOT [%ramIn%]==[true] IF NOT [%ramIn%]==[false] GOTO ramIn
SET ram=%ramIn%

IF [%ram%]==[true] (
GOTO xmsIn
) else (
GOTO paperIn
)


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

:paperIn
SET /p paperIn= Do you want to automatically download and use the newest paper version? (true or false):
IF [%paperIn%]==[] GOTO paperIn
IF NOT [%paperIn%]==[true] IF NOT [%paperIn%]==[false] GOTO paperIn
SET paper=%paperIn%

IF [%paper%]==[true] (
GOTO paperVersionIn
) else (
GOTO jarIn
)

:paperVersionIn
SET /p paperVersionIn= Enter the version you want to download (i.E. 1.16.5):
IF [%paperVersionIn%]==[] GOTO paperVersionIn
IF "x%paperVersionIn:1.=%"=="x%paperVersionIn%" GOTO paperVersionIn
SET paperVersion=%paperVersionIn%
SET jar=paper-%paperVersion%.jar
GOTO aikarFlags

:jarIn
SET /p jarIn= Enter the name of your server.jar (i.E. paper.jar):
IF [%jarIn%]==[] GOTO jarIn
IF "x%jarIn:.jar=%"=="x%jarIn%" GOTO jarIn
SET jar=%jarIn%
GOTO aikarFlags

:aikarFlags
SET /p aikarFlags= Do you want to use Aikar's Flags? (recommended) (true or false):
IF [%aikarFlags%]==[] GOTO aikarFlags
IF NOT [%aikarFlags%]==[true] IF NOT [%aikarFlags%]==[false] GOTO aikarFlags
SET aikarFlags=%aikarFlags%

:eulaIn
SET /p eulaIn= Do you want to automatically accept the minecraft eula? (true or false):
IF [%eulaIn%]==[] GOTO eulaIn
IF NOT [%eulaIn%]==[true] IF NOT [%eulaIn%]==[false] GOTO eulaIn
SET eula=%eulaIn%




SET currentPath=%cd%
cls

echo.
echo  ---------------------------------
echo             Settings:
echo.
IF %min% EQU %max% (
echo    java version: %min%
) ELSE (
echo    java version between %min% and %max%
)
echo    download paper.jar: %paper%
echo    auto-accept eula: %eula%
echo    jar-name: %jar%
IF [%ram%]==[true] (
echo    Xms: %xms%MB
echo    Xmx: %xmx%MB
)
echo  ---------------------------------
echo.
echo             created by:
echo                l4zs
echo.
IF %min% LEQ 8 (
echo.
echo  --------------------------------------------------------------- WARNING ---------------------------------------------------------------
echo.
echo  your selected Java version is pretty outdated, if you don't need to use this version I strongly recommend using a more recent version.
echo.
echo  --------------------------------------------------------------- WARNING ---------------------------------------------------------------
echo.
)
echo  ---------------------------------
echo    Searching for java versions..
echo    this may take several minutes
echo  ---------------------------------
echo.


SET javaPath=java
FOR /f "tokens=3" %%g IN ('java -version 2^>^&1 ^| findstr /i "version"') DO (
SET JAVAVER=%%g
)
SET JAVAVER=%JAVAVER:"=%
FOR /f "delims=. tokens=1-3" %%v IN ("%JAVAVER%") DO CALL :javaVersionCheck %%v %%w %%x

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
IF NOT "x%JAVAVER:.=%"=="x%JAVAVER%" (
	FOR /f "delims=. tokens=1-3" %%v IN ("%JAVAVER%") DO CALL :javaVersionCheck %%v %%w %%x
	GOTO End
)
SET /a ver=%JAVAVER%
:: IF %ver% EQU 16 (
CALL :javaVersionCheck %JAVAVER%,0,0
:: )
GOTO End


:javaVersionCheck

SET /a major=%1
SET /a minor=%2
SET build=%3

:: check java version
IF DEFINED major (
IF DEFINED minor (
IF %min% LEQ 8 (
	IF %major% EQU 1 (
		IF %minor% GEQ %min% (
			IF %minor% LEQ %max% (
				IF %minor% LEQ 8 (
					echo  FOUND JAVA VERSION: %minor%

					IF %paper%==true (
						CALL :downloadPaper
						GOTO End
					) else (
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
	GOTO End
)
)
IF %major% GEQ %min% (
	IF %major% LEQ %max% (
		echo  FOUND JAVA VERSION: %major%
		IF %paper%==true (
			CALL :downloadPaper
			GOTO End
		) else (
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

:downloadPaper
echo.
echo  Downloading paper.jar
echo.
SET "download=bitsadmin /transfer "Download latest paper-%paperVersion%.jar" /download /priority normal"
%download% "https://papermc.io/api/v1/paper/%paperVersion%/latest/download" %currentPath%\paper-%paperVersion%.jar
cls
echo.
echo  Download complete.
CALL :createBat
GOTO End

:createBat
IF [%aikarFlags%]==[true] (
SET jvmFlags=-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar
) else (
SET jvmFlags=-jar
)

IF [%ram%]==[true] (
SET content=%javaPath% -Xms%xms%M -Xmx%xmx%M %jvmFlags% %jar% nogui
) else (
SET content=%javaPath% %jvmFlags% %jar% nogui
)

echo.
echo  Creating start.bat
echo.
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
cls
echo.
IF %min% EQU %max% (
echo No Java %max% found.
) else (
echo No version between Java %min% and Java %max% found.
)
echo.
echo Please download it from https://adoptopenjdk.net/installation.html
echo.

:javaIn
SET /p javaIn= Do you want to automatically download java? (true or false):
IF [%javaIn%]==[] GOTO javaIn
IF NOT [%javaIn%]==[true] IF NOT [%javaIn%]==[false] GOTO javaIn
SET java=%javaIn%

IF [%java%]==[true] (
GOTO downloadJava
)
GOTO Exit

:downloadJava
cls
echo.
echo  Which java version do you want to download?
echo.
echo  [8] 8 (LTS)
echo  [9] 9
echo  [10] 10
echo  [11] 11 (LTS)
echo  [13] 13
echo  [14] 14
echo  [15] 15
echo  [16] 16 (Latest)
echo.

SET /p downloadJavaVersionIn= Enter which version you want to download: 
IF [%downloadJavaVersionIn%]==[] GOTO downloadJava
SET /a param=%downloadJavaVersionIn%+0
IF %param% == 0 GOTO downloadJava
IF %param% LEQ 7 GOTO downloadJava
IF %param%==12 GOTO downloadJava
IF %param% GEQ 17 GOTO downloadJava
SET /a downloadJavaVersion=%downloadJavaVersionIn%

:: Detect OS bit-ness on running system.  Assumes 32-bit if 64-bit components do not exist.
SET "ARCH=x64"
IF NOT EXIST "%SystemRoot%\SysWOW64\cmd.exe" (
	IF NOT DEFINED PROCESSOR_ARCHITEW6432 (
		echo Your System runs on 32-bit. Currently only 64-bit is supported.
		GOTO Exit
	)
)


SET "link=https://www.l4zs.de/r/jdk-%downloadJavaVersion%"


CALL :downloadJDK %link%

:downloadJDK
IF NOT EXIST "C:\Java" (
md C:\Java
)
SET "download=bitsadmin /transfer "Download Java %downloadJavaVersion% JDK" /download /priority normal"
%download% "%1" "C:\Java\jdk-%downloadJavaVersion%.zip"

powershell -Command Expand-Archive -Path C:\Java\jdk-%downloadJavaVersion%.zip -DestinationPath C:\Java

del C:\Java\jdk-%downloadJavaVersion%.zip

IF %downloadJavaVersion%==8 (
SET "folder=jdk8u282-b08"
) ELSE IF %downloadJavaVersion%==9 (
SET "folder=jdk-9.0.4+11"
) ELSE IF %downloadJavaVersion%==10 (
SET "folder=jdk-10.0.2+13"
) ELSE IF %downloadJavaVersion%==11 (
SET "folder=jdk-11.0.10+9"
) ELSE IF %downloadJavaVersion%==13 (
SET "folder=jdk-13.0.2+8"
) ELSE IF %downloadJavaVersion%==14 (
SET "folder=jdk-14.0.2+12"
) ELSE IF %downloadJavaVersion%==15 (
SET "folder=jdk-15.0.2+7"
) ELSE IF %downloadJavaVersion%==16 (
SET "folder=jdk-16+36"
)
cls
echo.
echo Downloaded Java %downloadJavaVersion%

SET "javaPath=C:\Java\%folder%\bin\java.exe"

IF %paper%==true (
	CALL :downloadPaper
	GOTO End
) else (
	CALL :createBat
	GOTO End
)

pause


GOTO Exit



:Exit
echo  Programm will exit now
echo.
PAUSE
EXIT
GOTO eof



:End
