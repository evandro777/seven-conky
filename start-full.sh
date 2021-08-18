cd "$(dirname "$(realpath "$0")")"

#COLORS
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

killall conky

echo -e "\n${ORANGE}Conky: Clock${NC}"
cd Full #Must start from the directory to avoid problem with relative paths in the script
setsid conky --pause=2 --config="Clock" --daemonize

echo -e "\n${ORANGE}Conky: Process Panel${NC}"
setsid conky --pause=0 --config="Process Panel" --daemonize

echo -e "\n${ORANGE}Conky: Disk${NC}"
setsid conky --pause=3 --config="Disk" --daemonize

echo -e "\n${ORANGE}Conky: Network Panel${NC}"
setsid conky --pause=4 --config="Network Panel - Lua" --daemonize
cd ..

cd Weather
echo -e "\n${ORANGE}Conky: Weather${NC}"
setsid conky --pause=1 --config="Weather" --daemonize
cd ..

cd Music
echo -e "\n${ORANGE}Conky: Music${NC}"
setsid conky --pause=5 --config="Music" --daemonize
cd ..
