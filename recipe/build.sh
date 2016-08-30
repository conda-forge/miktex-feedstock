#!/bin/bash
# FIXME: This is a hack to make sure the environment is activated.
# The reason this is required is due to the conda-build issue
# mentioned below.
#
# https://github.com/conda/conda-build/issues/910
#
source activate "${CONDA_DEFAULT_ENV}"

# Steps from: http://miktex.org/howto/build-unx
# Any args for CMAKE?
cmake -G "Unix Makefiles"
make
# Use ninja instead?
make install

# These steps are optional
# You use the MiKTeX configuration utility (initexmf) and the MiKTeX package manager (mpm) to configure "MiKTeX Tools" system-wide
# initexmf --admin --configure
# mpm --admin --update-db
# Once you have configured MiKTeX for the system, each user should create the per-user file name database
# initexmf --update-fndb
