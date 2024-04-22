#!/usr/bin/env bash
{ # this ensures the entire script is downloaded #

    #Example of usage this script:
    #Install with prompting: ./install.sh
    #Get help: ./install.sh --help
    #Install custom options example: ./install.sh --install-location="${HOME}/.conky/seven-conky/" --auto-start="y" --weather-key="111" --weather-city-id="222" --weather-unit="metric" --weather-language="pt_br"
    #Download and install: bash <(curl -s https://raw.githubusercontent.com/evandro777/seven-conky/main/install.sh)
    #Download and install with custom options: install_location="${HOME}/.conky/seven-conky/" auto_start="y" bash <(curl -s https://raw.githubusercontent.com/evandro777/seven-conky/main/install.sh)

    # COLORS
    RED='\033[0;31m'
    ORANGE='\033[0;33m'
    NC='\033[0m' # No Color

    # Help function
    show_help() {
        echo "Usage: $0 [OPTIONS]"
        echo "Options:"
        echo "  --install-location=<path>   Specify the installation location"
        echo "  --auto-start=<y/n>          Enable autostart (y/n)"
        echo "  --weather-key=<key>         Open Weather Map API Key"
        echo "  --weather-city-id=<id>      Open Weather City ID"
        echo "  --weather-unit=<unit>       Units (metric, standard, imperial)"
        echo "  --weather-language=<lang>   Language (en, pt_br, sp, es)"
        echo "  --help                      Show this help message"
    }

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --install-location=*) install_location="${1#*=}" ;;
            --install-location)
                install_location="$2"
                shift
                ;;
            --auto-start=*) auto_start="${1#*=}" ;;
            --auto-start)
                auto_start="$2"
                shift
                ;;
            --weather-key=*) weather_key="${1#*=}" ;;
            --weather-key)
                weather_key="$2"
                shift
                ;;
            --weather-city-id=*) weather_city_id="${1#*=}" ;;
            --weather-city-id)
                weather_city_id="$2"
                shift
                ;;
            --weather-unit=*) weather_unit="${1#*=}" ;;
            --weather-unit)
                weather_unit="$2"
                shift
                ;;
            --weather-language=*) weather_language="${1#*=}" ;;
            --weather-language)
                weather_language="$2"
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown parameter passed: $1"
                exit 1
                ;;
        esac
        shift
    done

    # Prompt for install location if not provided
    if [ -z "$install_location" ]; then
        echo -e "${ORANGE}Install location (empty will be: ~/.conky/seven-conky): ${NC}"
        read -rp "" install_location
    fi
    if [ -z "$install_location" ]; then
        install_location="${HOME}/.conky/seven-conky"
    fi

    # Prompt for autostart if not provided
    while [ -z "$auto_start" ]; do
        echo -e "${ORANGE}Enable autostart? [Y]es | (empty)[N]o: ${NC}"
        read -rp "" prompt
        case $prompt in
            [Yy]*)
                auto_start="y"
                ;;
            [Nn]*)
                auto_start="n"
                ;;
            "")
                auto_start="n"
                ;;
            *)
                echo "Answer Y, N or leave empty"
                ;;
        esac
    done

    # Prompt for weather parameters if not provided
    if [ -z "$weather_unit" ]; then
        echo -e "${ORANGE}Units [metric (or empty): Celsius, standard: Kelvin, imperial: Fahrenheit]: ${NC}"
        read -rp "" weather_unit
    fi
    if [ -z "$weather_unit" ]; then
        weather_unit="metric"
    fi

    if [ -z "$weather_language" ]; then
        echo -e "${ORANGE}Language [en (or empty): English, pt_br: Português Brasil, sp, es: Spanish] (get a complete list at: https://openweathermap.org/current#multi): ${NC}"
        read -rp "" weather_language
    fi
    if [ -z "$weather_language" ]; then
        weather_language="en"
    fi

    # Prompt for weather key if not provided
    while [ -z "$weather_key" ]; do
        echo -e "${ORANGE}Open Weather Map API Key (To get one, register an account and create an api key on https://home.openweathermap.org/api_keys): ${NC}"
        read -rp "" weather_key
    done

    # Prompt for weather city id if not provided
    while [ -z "$weather_city_id" ]; do
        echo -e "${ORANGE}Open Weather City Id: ${NC}"
        echo -e "To get the city id to get the weather, search your city id at: [https://openweathermap.org/], then copy the link of the city, something like: https://openweathermap.org/city/3457095 and use only the end number: 3457095"
        read -rp "" weather_city_id
    done

    echo "$install_location"
    echo "$auto_start"
    echo "$weather_key"
    echo "$weather_city_id"
    echo "$weather_unit"
    echo "$weather_language"
    exit

    # Download and install Conky
    echo "Downloading the most recent Conky"
    wget --directory-prefix="${install_location}" https://github.com/evandro777/seven-conky/archive/refs/heads/main.zip
    echo "Installing Conky in: $install_location"
    unzip -q -o "${install_location}/main.zip" -d "${install_location}"
    cp -rlf "${install_location}/seven-conky-main/"* "${install_location}"
    rm -r "${install_location}/seven-conky-main/"
    rm "${install_location}/main.zip"

    # Configure weather
    weather_config_location="${install_location}/Weather/conky-weather/WeatherConfig.sh"
    cp "${install_location}/Weather/conky-weather/WeatherConfig.sample.sh" "${weather_config_location}"
    sed -i 's/weather_key=.*$/weather_key="'$weather_key'"/g' "${weather_config_location}"
    sed -i 's/weather_city_id=.*$/weather_city_id="'$weather_city_id'"/g' "${weather_config_location}"
    sed -i 's/weather_unit=.*$/weather_unit="'$weather_unit'"/g' "${weather_config_location}"
    sed -i 's/weather_language=.*$/weather_language="'$weather_language'"/g' "${weather_config_location}"

    # Run autostart script
    . "${install_location}/autostart.sh" "$auto_start"

} # this ensures the entire script is downloaded #
