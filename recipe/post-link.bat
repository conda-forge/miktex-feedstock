@echo off

rem initialize the per user DB for the current user...
"%PREFIX%\Scripts\initexmf.exe" --update-fndb --quiet
if errorlevel 1 exit 1

rem latex packages which are needed by nbconvert and probably other pdf producers
rem this is just a convenience install: miktex will install any missing package on the fly
rem don't check for errors so that this succeeds even if offline, etc...
"%PREFIX%\Scripts\mpm.exe" --update-db --quiet
for %%x in (adjustbox booktabs collectbox fancyvrb ifoddpage mptopdf ucs url caption xcolor upquote ulem mathpazo) do (
	"%PREFIX%\Scripts\mpm.exe" --quiet --install %%x
)
rem No final check as this should succeed even if the conda package is updated and the latex packages are already installed
