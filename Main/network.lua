-- SCRIPT FOR DINAMIC GET INTERFACES

-- DOESN'T HAVE BYTES RECEIVED
-- ip -br link show | grep -v UNKNOWN | awk '{print $1}'

-- DOESN'T HAVE BYTES RECEIVED
-- local file = io.popen("ls --sort=time /sys/class/net/ | sed '/lo/d'")

-- WITH OSQUERY GET THE MOST USED INTERFACE
-- osqueryi 'SELECT interface, type, obytes, mac, mtu FROM interface_details WHERE type <> 4 ORDER BY obytes DESC'
-- osqueryi --header=false --list 'SELECT interface, type, obytes, mac, mtu FROM interface_details WHERE type <> 4 ORDER BY type ASC, obytes DESC'

-- ifconfig -s is similar to netstat -i
-- LIST INTERFACES, REMOVE HEADER LINES & LOOPBACK INTERFACE, ORDER BY BYTES RECEIVED (REVERSE) AND PRINT ONLY FIRST COLUMN AND ONLY FIRST LINE
-- There is a problem with this code, interface names are limited for 8 characters
-- ifconfig -s | sed 1,1d | grep -v LRU | sort -n -r -k 3,3 | awk '{print $1}'

-- LIST INTERFACES, REMOVE HEADER LINES & LOOPBACK INTERFACE, ORDER BY BYTES RECEIVED (REVERSE) AND PRINT ONLY FIRST COLUMN AND ONLY FIRST LINE
-- There is a problem with this code, interface names are limited for 8 characters
-- netstat -i | sed 1,2d | grep -v LRU | sort -n -r -k 3,3 | awk '{print $1}'

-- LIST INTERFACES, GET ONLY CONNECTED & wifi & ethernet AND PRINT ONLY FIRST COLUMN AND ONLY FIRST LINE
-- nmcli --colors=no device | grep -w 'connected' | grep -E 'wifi |ethernet ' | awk '{print $1}' | sed -n '1p'

local file = io.popen("nmcli --colors=no device | grep -w 'connected' | grep -E 'wifi |ethernet ' | awk '{print $1}' | sed -n '1p'")
local result = file:read("*a")
file:close()
local interface = result:gsub("%s+", "") --remove whitespaces

listresult = ""
listresult = listresult.."${if_up "..tostring(interface).."}"
listresult = listresult.."${color1}${font FontAwesome:size=11} ${font}${color}${offset 9}${font sans serif:size=9}${addrs "..tostring(interface).."}${font}\n"
listresult = listresult.."${voffset 4}"
listresult = listresult.."${color1}${font FontAwesome:size=11} ${font}${color} ${offset 9}${font sans serif:size=9}${totaldown "..tostring(interface).."}  |  ${downspeedf "..tostring(interface).."} KiB/s${font}\n"
listresult = listresult.."${voffset 4}"
listresult = listresult.."${color1}${font FontAwesome:size=11} ${font}${color} ${offset 9}${font sans serif:size=9}${totalup "..tostring(interface).."}  |  ${upspeedf "..tostring(interface).."} KiB/s${font}"
listresult = listresult.."${endif}"

function conky_mynetwork()
	return listresult
end

--print(conky_mynetwork())
