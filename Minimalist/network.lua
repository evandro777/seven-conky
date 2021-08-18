-- SCRIPT FOR DINAMIC GET INTERFACES

function explode(str, div) -- credit: http://richard.warburton.it
	if (div=='') then return false end
	local pos,arr = 0,{}
	-- for each divider found
	for st,sp in function() return string.find(str,div,pos) end do
		table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
		pos = sp + 1 -- Jump past current divider
	end
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
	return arr
end

--function print_r(arr, indentLevel)
	--local str = ""
	--local indentStr = "#"

	--if(indentLevel == nil) then
		--print(print_r(arr, 0))
		--return
	--end

	--for i = 0, indentLevel do
		--indentStr = indentStr.."\t"
	--end

	--for index,value in pairs(arr) do
		--if type(value) == "table" then
			--str = str..indentStr..index..": \n"..print_r(value, (indentLevel + 1))
		--else 
			--str = str..indentStr..index..": "..value.."\n"
		--end
	--end
	--return str
--end


--local file = io.popen("ls --sort=time /sys/class/net/ | sed '/lo/d'")

-- WITH OSQUERY GET THE MOST USED INTERFACE
-- osqueryi 'SELECT interface, type, obytes, mac, mtu FROM interface_details WHERE type <> 4 ORDER BY obytes DESC'
local file = io.popen("osqueryi --header=false --list 'SELECT interface, type, obytes, mac, mtu FROM interface_details WHERE type <> 4 ORDER BY type ASC, obytes DESC'")
local result = file:read("*a")
file:close()
local linesArray
linesArray = explode(result, '[\n\r]+')

show_graph = 0
listresult = ""
for index,value in pairs(linesArray) do
	if(value ~= "") then
		colsArray = explode(value, '|')
		local interface = colsArray[1]
		local type = colsArray[2]
		local bytes_received = colsArray[3]
		local mac = colsArray[4]
		
		--print_r(colsArray)
		--print(type)
		--os.exit()
		
		if(tonumber(type) == 1) then -- ONLY PHYSICAL INTERFACES (IGNORE VIRTUAL, LIKE VPN)
			if(tonumber(bytes_received) > 0 and show_graph == 0) then -- HAS BYTES RECEIVED > DISPLAY GRAPHICS
				show_graph = 1
				listresult = listresult.."${if_up "..tostring(interface).."}\n"
				listresult = listresult.."${voffset 4}"
				listresult = listresult.."${offset 405}${color FFA300}${font FontAwesome:size=11} ${font}${color}${offset 9}${font sans serif:size=9}${addrs "..tostring(interface).."}${font}\n"
				listresult = listresult.."${voffset 4}"
				listresult = listresult.."${offset 405}${color FFA300}${font FontAwesome:size=11} ${font}${color} ${offset 9}${font sans serif:size=9}${totaldown "..tostring(interface).."}  |  ${downspeedf "..tostring(interface).."} KiB/s${font}\n"
				listresult = listresult.."${voffset 4}"
				listresult = listresult.."${offset 405}${color FFA300}${font FontAwesome:size=11} ${font}${color} ${offset 9}${font sans serif:size=9}${totalup "..tostring(interface).."}  |  ${upspeedf "..tostring(interface).."} KiB/s${font}"
				listresult = listresult.."${endif}"
			end
		end
	end
end


function conky_mynetwork()
	--return "aasdasdasd⬇️"
	return listresult
end

print(conky_mynetwork())
