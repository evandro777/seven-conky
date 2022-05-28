# Seven Conky

[![made-for-linux](https://img.shields.io/badge/Linux-1f425f?logo=linux)](https://www.linux.org/)
[![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-orange)](https://opensource.org/licenses/GPL-3.0)

## Conky with clock, disk, network, process, weather, music

* Conky Disks: show all disks dynamically, even mounted flash drives

* Conky Network: get network interface dynamically (try to guess to main one)

* Conky Music: integrates with Spotify and Clementine

* Conky Weather: uses OpenWeatherMap

The ideal display resolution is 1980 x 1080, but it should run fine even on 1366 x 768 (but the sizes will be bigger)

## Screenshot

![Screenshot](screenshot.png)

## Start Conky

`./start-conky.sh`

## Weather conky

Weather conky, must be configured manually to set an api token and city id.

Create a config file from a sample one, copy: "Weather/conky-weather/WeatherConfig.sample.sh" to "Weather/conky-weather/WeatherConfig.sh"

Using bash on seven-conky root folder:

```bash
cp Weather/conky-weather/WeatherConfig.sample.sh Weather/conky-weather/WeatherConfig.sh
```

Register an account and create an api key on [Open Weather Map API](https://home.openweathermap.org/api_keys)

To get the city id to get the weather, search your city id at: [Open Weather Map](https://openweathermap.org/), then copy the link of the city, something like: <https://openweathermap.org/city/3457095> and use only the end number: 3457095

Set these configurations in the file Weather/conky-weather/WeatherConfig.sh

## Installing conky on Ubuntu/Mint

```bash
sudo apt install conky conky-all
```

## Install FontAwesome on Ubuntu/Mint

```bash
sudo apt install fonts-font-awesome
```

## To get temperature, need to allow regular user to execute hddtemp

```bash
sudo chmod +s /usr/sbin/hddtemp
```

## Easy install this script

```bash
bash <(curl -s https://raw.githubusercontent.com/evandro777/seven-conky/main/install.sh)
```

## Problems known

Listing network interfaces is using ifconfig -s (similar to netstat -i, which is deprecated), and there's a bug which cuts long interface's name.
Then some interfaces may not show.

[Discussion](https://bugzilla.redhat.com/show_bug.cgi?id=1557470)

## Some code and layouts which are inspired

[Gothan Conky](https://www.gnome-look.org/p/1084945)

[Conky-Spotify](https://github.com/Madh93/conky-spotify)

[Jelly-conky](https://github.com/muhammad-yasmin/jelly-conky)
