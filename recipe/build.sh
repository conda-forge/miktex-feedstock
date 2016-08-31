#!/bin/bash

# Steps from: http://miktex.org/howto/build-unx
# Any args for CMAKE?
cmake -G "Unix Makefiles" \
	-Wno-dev \
	-DWITH_UI_QT:BOOL=OFF
	
make
# Use ninja instead?
make install

# These steps are optional
# You use the MiKTeX configuration utility (initexmf) and the MiKTeX package manager (mpm) to configure "MiKTeX Tools" system-wide
# initexmf --admin --configure
# mpm --admin --update-db
# Once you have configured MiKTeX for the system, each user should create the per-user file name database
# initexmf --update-fndb
