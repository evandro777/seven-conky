cd "$(dirname "$(realpath "$0")")"

#COLORS
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

killall conky

echo -e "\n${ORANGE}Conky: Minimalist${NC}"
cd Minimalist #Must start from the directory to avoid problem with relative paths in the script
setsid conky --pause=2 --config="Minimalist" --daemonize
cd ..

cd Weather
echo -e "\n${ORANGE}Conky: Weather${NC}"
setsid conky --pause=1 --config="Weather" --daemonize
cd ..

cd Music
echo -e "\n${ORANGE}Conky: Music${NC}"
setsid conky --pause=5 --config="Music" --daemonize
cd ..
