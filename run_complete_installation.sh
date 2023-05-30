#!/bin/sh
echo "Setting up python build environment..."
python -m venv venv
source ./venv/bin/activate
pip3 install -r requirements.txt
echo "Setting up directory structure..."
./setup_directories.sh
python3 ./main.py $1
./setup_resolve.sh
install -Dm755 resolve.sh /app/bin/resolve.sh