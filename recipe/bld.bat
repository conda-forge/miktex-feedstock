
rem I want to see my commands when they go wrong...
echo on

rem first compile, so errors are seen early...
rem build the wrapper: pandoc expects commands like pdflatex to be exe files,
rem batch files do not work

rem compile using the MS compilers
cl -DGUI=0 -DDEBUG=0 "%RECIPE_DIR%\wrapper.c"
if errorlevel 1 exit 1

dumpbin /IMPORTS wrapper.exe

rem [remove] debugging stuff...
dir /s/b

rem extract the beast...
echo Extracting...
echo start "" /WAIT "basic-miktex-%PKG_VERSION%-x64.exe" --portable="%LIBRARY_PREFIX%\miktex" --unattended
start "" /WAIT "basic-miktex-%PKG_VERSION%-x64.exe" --portable="%LIBRARY_PREFIX%\miktex" --unattended

tasklist | find "miktex"
sleep 2
tasklist | find "miktex"

echo %ERRORLEVEL%
echo Extracted...

rem [remove] debugging stuff...
dir /s/b

dir /s/b %LIBRARY_PREFIX%\miktex

sleep 120
tasklist | find "miktex"

dir /s/b

dir /s/b %LIBRARY_PREFIX%\miktex


if errorlevel 1 exit 1

rem SCRIPTS dir should already be created by 7za install
if not exist %SCRIPTS% mkdir %SCRIPTS% || exit 1

rem add exe versions for all commands...
for %%f in ("%LIBRARY_PREFIX%\miktex\texmfs\install\miktex\bin\x64\*.exe") do (
	echo copy "wrapper.exe" "%SCRIPTS%\%%~nf.exe"
	copy "wrapper.exe" "%SCRIPTS%\%%~nf.exe"
	if errorlevel 1 exit 1
)

del wrapper.exe
del wrapper.obj

rem DO NOT INSTALL PACKAGES AS ADMIN: it adds a lot of cache files which have
rem the path hardcoded to the current locations, so let that happen in the user
rem install and on the users machine:

rem Change the install variant to a regular one, so that latex packages
rem installed by the user go into the users home directory...
(
echo ;;; MiKTeX startup information
echo.
echo ;;; The effect of this file is that the main install location in the conda env
echo ;;; is not touched by the latex package installer and all packages are installed
echo ;;; into a location under USERPROFILE.
echo.
echo [Auto]
echo Config=Regular
echo.
echo [PATHS]
echo CommonInstall=..\..\install
echo CommonData=..\..\data
echo CommonConfig=..\..\config
) > "%PREFIX%\Library\miktex\texmfs\install\miktex\config\miktexstartup.ini"

rem Also make miktex install packages automatically *without* asking
initexmf.exe --set-config-value [MPM]AutoInstall=1
