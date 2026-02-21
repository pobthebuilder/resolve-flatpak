#!/bin/sh
echo "Setting up python build environment..."
python -m venv venv
source ./venv/bin/activate
pip3 install -r requirements.txt
echo "Setting up directory structure..."
./setup_directories.sh $1
python3 ./main.py $1
chmod +x ./DaVinci_Resolve_*_Linux.run
./setup_resolve.sh $1
install -Dm755 resolve.sh /app/bin/resolve.sh
