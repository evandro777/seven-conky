# seven-conky
### Conky with clock, disk, network, process, weather, music

* Conky Disks: show all disks dinamically, even mounted flash drives

* Conky Network: get all network interfaces dinamically (in full option), and gets the main one on Minimalist

* Conky Music: integrates with Spotify and Clementine

* Conky Weather: uses OpenWeatherMap

#### Option 1: With minimalist interface
	./start-minimalist.sh
![Minimalist image](Minimalist.png)

#### Option 2: With a full, more detailed interface
	./start-full.sh
![Full image](Full.png)

## Weather conky
Weather conky, must be configured manually to set an api token and city id.

Create a config file from a sample one, copy: "Weather/conky-weather/WeatherConfig.sample.sh" to "Weather/conky-weather/WeatherConfig.sh"

Using bash on seven-conky root folder:

	cp Weather/conky-weather/WeatherConfig.sample.sh Weather/conky-weather/WeatherConfig.sh

Register an account and create an api key on [Open Weather Map API](https://home.openweathermap.org/api_keys)

To get the city id to get the weather, search your city id at: [Open Weather Map](https://openweathermap.org/), then copy the link of the city, something like: https://openweathermap.org/city/3457095 and use only the end number: 3457095

Set these configurations in the file Weather/conky-weather/WeatherConfig.sh

## Installing conky on Ubuntu/Mint
	sudo apt install conky conky-all

## Install dependencys on Ubuntu/Mint
#### FontAwesome:
	sudo apt install fonts-font-awesome

#### [osquery](https://github.com/osquery/osquery) used for listing network interfaces:
	export OSQUERY_KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $OSQUERY_KEY
	sudo add-apt-repository 'deb [arch=amd64] https://pkg.osquery.io/deb deb main'
	apt update
	sudo apt install -y osquery

## To get temperature, need to allow regular user to execute hddtemp
	sudo chmod +s /usr/sbin/hddtemp

## Easy install this script
	bash <(curl -s https://raw.githubusercontent.com/evandro777/seven-conky/main/install.sh)

## Some code and layouts which are inspired
[Gothan Conky](https://www.gnome-look.org/p/1084945)

[Conky-Spotify](https://github.com/Madh93/conky-spotify)

[Jelly-conky](https://github.com/muhammad-yasmin/jelly-conky)
