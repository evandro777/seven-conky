#!/bin/bash

cd "$(dirname "$(realpath "$0")")"

#COLORS
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

killall conky

monitorWidth=$(xrandr | grep ' connected primary' | cut -d"+" -f2)

echo -e "\n${ORANGE}Conky: Main${NC}"
cd Main #Must start from the directory to avoid problem with relative paths in the script
setsid conky --pause=1 --config="Main" -x $((230 + $monitorWidth))  -y 10 --daemonize

echo -e "\n${ORANGE}Conky: Network Lua${NC}"
setsid conky --pause=2 --config="NetworkLua" -x $((800 + $monitorWidth)) -y 130 --daemonize

echo -e "\n${ORANGE}Conky: Disk${NC}"
setsid conky --pause=3 --config="DiskLua" -x $((430 + $monitorWidth)) -y 130 --daemonize

echo -e "\n${ORANGE}Conky: Process${NC}"
setsid conky --pause=4 --config="Process" -x $((1010 + $monitorWidth)) -y 130 --daemonize

cd ..

cd Weather
echo -e "\n${ORANGE}Conky: Weather${NC}"
setsid conky --pause=5 --config="Weather" -x $((10 + $monitorWidth)) -y 10 --daemonize
cd ..

cd Music
echo -e "\n${ORANGE}Conky: Music${NC}"
setsid conky --pause=6 --config="Music" -x $((10 + $monitorWidth)) -y 45 --daemonize
cd ..
