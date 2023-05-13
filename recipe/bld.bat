@echo on
setlocal EnableDelayedExpansion

set "install_prefix=%LIBRARY_PREFIX%\miktex"
set "common_config=%install_prefix%\texmfs\config"
set "common_data=%install_prefix%\texmfs\data"
set "common_install=%install_prefix%\texmfs\install"

set "pkg_repo=%CD%\repo"
set "package_set=essential"


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


rem build the wrapper: pandoc expects commands like pdflatex to be exe files,
rem batch files do not work
rem add exe versions for all commands...
if not exist %SCRIPTS% mkdir %SCRIPTS% || exit 1
bash -euc "build-symlink-exe.sh ${common_install//\\\\//}/miktex/bin/x64/*.exe ${SCRIPTS}"
if errorlevel 1 exit 1


rem Make miktex install packages automatically *without* asking...
initexmf --set-config-value [MPM]AutoInstall=1
if errorlevel 1 exit 1

rem Update package database...
miktex packages update-package-database
if errorlevel 1 exit 1

rem latex packages which are needed by nbconvert and probably other pdf producers
rem this is just a convenience install: miktex will install any missing package on the fly
miktex packages install ^
    adjustbox booktabs collectbox fancyvrb ifoddpage mptopdf ucs url caption xcolor upquote ulem mathpazo
if errorlevel 1 exit 1

rem Update packages and filename database...
miktex packages update
if errorlevel 1 exit 1
miktex fndb refresh
if errorlevel 1 exit 1
