#!/usr/bin/env bash
#Example of usage this script:
#Install with prompting: ./install.sh
#Install custom options: ./install.sh -l "${HOME}/.conky/seven-conky/" -a "m"

#COLORS
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/"

autoStart="$1"

if [ "$autoStart" == "-d" ]; then
	autoStart=""
else
	autoStart="y"
fi

sevenConkyAutostartFile="${HOME}/.config/autostart/seven-conky.desktop"

sevenConkyAutostartContent='[Desktop Entry]
Type=Application
Exec="'${scriptDir}start-${autoStart}.sh'"
X-GNOME-Autostart-enabled=true
NoDisplay=false
Hidden=false
Name[en_US]=seven-conky
Comment[en_US]=Start seven-conky
X-GNOME-Autostart-Delay=5
X-GNOME-Autostart-enabled=true'

if [ -n "$autoStart" ]; then
	echo -e "${ORANGE}Creating startup conky${NC}"
	#CREATE FILE WITH USER PERMISSION. USING ECHO OR PRINTF DIRECTLY WILL CREATE WITH ROOT PERMISSION
	printf "${sevenConkyAutostartContent}" | tee "${sevenConkyAutostartFile}" > /dev/null
else
	echo -e "${ORANGE}Removing startup conky${NC}"
	rm "${sevenConkyAutostartFile}"
fi
