
7za x miktex-portable-%PKG_VERSION%.exe -o%LIBRARY_PREFIX%\miktex > NUL
if errorlevel 1 exit 1

rem SCRIPTS dir should already be created by 7za install
mkdir "%SCRIPTS%"
if errorlevel 1 exit 1

rem build the wrapper: pandoc expects commands like pdflatex to be exe files,
rem batch files do not work :-/

rem compile using the MS compilers
cl -DGUI=0 /MT /Fewrapper.exe "wrapper.c"
if errorlevel 1 exit 1

rem add exe versions for all commands...
for %%f in ("%LIBRARY_PREFIX%\miktex\miktex\bin\*.exe") do (
	copy "wrapper.exe" "%SCRIPTS%\%%~nf.exe"
)
if errorlevel 1 exit 1

del wrapper.exe

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
echo CommonInstall=..\..
echo CommonData=..\..
echo CommonConfig=..\..
) > "%PREFIX%\Library\miktex\miktex\config\miktexstartup.ini"

