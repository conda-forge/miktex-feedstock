cmake -G "Unix Makefiles"
make
sudo make install
sudo initexmf --admin --configure
sudo mpm --admin --update-db
initexmf --update-fndb
