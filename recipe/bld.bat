@echo on
setlocal EnableDelayedExpansion

set "install_prefix=%LIBRARY_PREFIX%\miktex"
set "common_config=%install_prefix%\texmfs\config"
set "common_data=%install_prefix%\texmfs\data"
set "common_install=%install_prefix%\texmfs\install"

set "miktex_bin=%common_install%\miktex\bin\x64"
set "relative_path=!miktex_bin:%PREFIX%=!\"
set "pkg_repo=%CD%\repo"
set "package_set=essential"


rem first compile, so errors are seen early...
rem build the wrapper: pandoc expects commands like pdflatex to be exe files,
rem batch files do not work

rem compile using the MS compilers
cl -DGUI=0 -DDEBUG=0 ^
    "-DRELATIVE_PATH=\"!relative_path:\=\\!\\\"" ^
    "%RECIPE_DIR%\wrapper.c"
if errorlevel 1 exit 1

dumpbin /IMPORTS wrapper.exe


rem install the beast...
.\miktexsetup_standalone.exe ^
    --verbose ^
    "--local-package-repository=%pkg_repo%" ^
    "--package-set=%package_set%" ^
    download
if errorlevel 1 exit 1

.\miktexsetup_standalone.exe ^
    --verbose ^
    "--local-package-repository=%pkg_repo%" ^
    "--package-set=%package_set%" ^
    --use-registry=no ^
    "--portable=%install_prefix%" ^
    "--common-config=%common_config%" ^
    "--common-data=%common_data%" ^
    "--common-install=%common_install%" ^
    install
if errorlevel 1 exit 1


if not exist %SCRIPTS% mkdir %SCRIPTS% || exit 1

rem add exe versions for all commands...
for %%f in ("%miktex_bin%\*.exe") do (
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
