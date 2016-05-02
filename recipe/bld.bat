

7za x miktex-portable-%PKG_VERSION%.exe -o%LIBRARY_PREFIX%\miktex
if errorlevel 1 exit 1


rem SCRIPTS dir should already be created by 7za install
mkdir "%SCRIPTS%"
if errorlevel 1 exit 1

rem latex tools must be run from miktex tree
for %%f in ("%LIBRARY_PREFIX%\miktex\miktex\bin\*.exe") do (
	echo @%%~dp0\..\Library\miktex\miktex\bin\%%~nf %%* >> "%SCRIPTS%\%%~nf.bat"
)
if errorlevel 1 exit 1

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

