#!/bin/bash
cd "$(dirname "$(realpath "$0")")"

#COLORS
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

while getopts l:a: opts; do
	case ${opts} in
		l) #install location
			installLocation="${OPTARG}" ;;
		a) #choose script to autostart
			autoStart=${OPTARG} ;;
	esac
done

if [ -z "$installLocation" ]; then
	echo -e "${ORANGE}Install location (empty will be: ~/.conky/seven-conky): ${NC}"
	read -p "" installLocation
fi
if [ -z "$installLocation" ]; then
	installLocation="${HOME}/.conky/seven-conky/"
fi

if [ -z "$autoStart" ]; then
	while true; do
		echo -e "${ORANGE}Enable autostart? [F]ull | [M]inimalist (leave empty to disable): ${NC}"
		read -p "" prompt
		case $prompt in
			[Ff]* ) autoStart="f"; break;;
			[Mm]* ) autoStart="m"; break;;
			"" ) autoStart=""; break;;
			* ) echo "Answer F, M or leave empty";;
		esac
	done
fi

case $autoStart in
	[Ff]* ) autoStart="start-full.sh";;
	[Mm]* ) autoStart="start-minimalist.sh";;
esac

echo "Downloading the most recent conky"
wget --directory-prefix="${installLocation}" https://github.com/evandro777/seven-conky/archive/refs/heads/main.zip

echo "Installing conky in: $installLocation"
unzip -q -o "${installLocation}main.zip" -d "${installLocation}"

#mv doesn't overwrite subfolders
#mv -f "${installLocation}seven-conky-main/"* --target-directory="${installLocation}"
cp -rlf "${installLocation}seven-conky-main/"* "${installLocation}"
rm -r "${installLocation}seven-conky-main/"

rm "${installLocation}main.zip"

sevenConkyAutostartFile="${HOME}/.config/autostart/seven-conky.desktop"

sevenConkyAutostartContent='[Desktop Entry]
Type=Application
Exec="'${installLocation}${autoStart}'"
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
