#!/bin/bash

cd "$(dirname "$(realpath "$0")")"

#COLORS
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# Function to display help
display_help() {
    echo "Usage: $0 [--right-position=<value>]"
    echo "Optional parameter to set the right position of the primary monitor."
    echo "Accepts positive and negative numbers. The position is relative to the primary monitor."
    echo "To adjust the display, try numbers like the width value of the primary monitor, positive or negative."
}

# Check if --help option is provided
if [ "$1" == "--help" ]; then
    display_help
    exit 0
fi

# Set default value for right_position
#right_position=$(xrandr | grep ' connected primary' | cut -d"+" -f2)
right_position=0

# Loop through all command line arguments
for arg in "$@"; do
    # Check if the argument starts with '--right_position='
    if [[ "$arg" == --right-position=* ]]; then
        # Extract the value after the '=' sign
        right_position="${arg#*=}"
        break  # Exit the loop once the right_position is found
    fi
done

killall conky

echo -e "\n${ORANGE}Conky: Main${NC}"
cd Main #Must start from the directory to avoid problem with relative paths in the script
setsid conky --pause=1 --config="Main" -x $((230 + $right_position))  -y 10 --daemonize

echo -e "\n${ORANGE}Conky: Network Lua${NC}"
setsid conky --pause=2 --config="NetworkLua" -x $((800 + $right_position)) -y 130 --daemonize

echo -e "\n${ORANGE}Conky: Disk${NC}"
setsid conky --pause=3 --config="DiskLua" -x $((430 + $right_position)) -y 130 --daemonize

echo -e "\n${ORANGE}Conky: Process${NC}"
setsid conky --pause=4 --config="Process" -x $((1010 + $right_position)) -y 130 --daemonize

cd ..

cd Weather
echo -e "\n${ORANGE}Conky: Weather${NC}"
setsid conky --pause=5 --config="Weather" -x $((10 + $right_position)) -y 10 --daemonize
cd ..

cd Music
echo -e "\n${ORANGE}Conky: Music${NC}"
setsid conky --pause=6 --config="Music" -x $((10 + $right_position)) -y 45 --daemonize
cd ..
