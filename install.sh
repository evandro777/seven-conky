#!/usr/bin/env bash
{ # this ensures the entire script is downloaded #

#Example of usage this script:
#Install with prompting: ./install.sh
#Install custom options: ./install.sh -l "${HOME}/.conky/seven-conky/" -a "minimalist"
#Download and install: bash <(curl -s https://raw.githubusercontent.com/evandro777/seven-conky/main/install.sh)
#Download and install with custom options: installLocation="${HOME}/.conky/seven-conky/" autoStart="minimalist" bash <(curl -s https://raw.githubusercontent.com/evandro777/seven-conky/main/install.sh)

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
	[Ff]* ) autoStart="full";;
	[Mm]* ) autoStart="minimalist";;
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

# WEATHER CONFIG
weatherConfigLocation="${installLocation}/Weather/conky-weather/WeatherConfig.sh"
cp "${installLocation}/Weather/conky-weather/WeatherConfig.sample.sh" "${weatherConfigLocation}"

if [ -z "$weatherKey" ]; then
	echo -e "${ORANGE}Open Weather Map API Key (To get one, register an account and create an api key on https://home.openweathermap.org/api_keys): ${NC}"
	read -p "" weatherKey
	sed -i 's/weatherKey=.*$/weatherKey="'$weatherKey'"/g' "${weatherConfigLocation}"
fi

if [ -z "$weatherCityId" ]; then
	echo -e "${ORANGE}Open Weather City Id: ${NC}"
	echo -e "To get the city id to get the weather, search your city id at: [https://openweathermap.org/], then copy the link of the city, something like: https://openweathermap.org/city/3457095 and use only the end number: 3457095"
	read -p "" weatherCityId
	sed -i 's/weatherCityId=.*$/weatherCityId="'$weatherCityId'"/g' "${weatherConfigLocation}"
fi

if [ -z "$weatherUnit" ]; then
	echo -e "${ORANGE}Units [standard: Kelvin, metric: Celsius, imperial: Fahrenheit]: ${NC}"
	read -p "" weatherUnit
	sed -i 's/weatherUnit=.*$/weatherUnit="'$weatherUnit'"/g' "${weatherConfigLocation}"
fi

if [ -z "$weatherLanguage" ]; then
	echo -e "${ORANGE}Language [en: English, pt_br: Português Brasil, sp, es: Spanish] (get a complete list at: https://openweathermap.org/current#multi): ${NC}"
	read -p "" weatherLanguage
	sed -i 's/weatherLanguage=.*$/weatherLanguage="'$weatherLanguage'"/g' "${weatherConfigLocation}"
fi


sevenConkyAutostartFile="${HOME}/.config/autostart/seven-conky.desktop"

sevenConkyAutostartContent='[Desktop Entry]
Type=Application
Exec="'${installLocation}start-${autoStart}.sh'"
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

} # this ensures the entire script is downloaded #
