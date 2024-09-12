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

local function isEmpty(s)
	return s == nil or s == ''
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


function conky_disk()
	-- MORE COMPLETE INFO
	-- lsblk -o NAME,PATH,TYPE,SIZE,HOTPLUG,MODEL,MOUNTPOINT,FSTYPE,FSSIZE,FSAVAIL,FSUSED,LABEL,VENDOR

	-- df -H -T -x squashfs -x tmpfs -x overlay -x devtmpfs | awk /dev/ | tr -s ' '
	-- lsblk -n -o NAME,PATH,TYPE,SIZE,HOTPLUG,MODEL,MOUNTPOINT,FSTYPE,FSSIZE,FSAVAIL,FSUSED | awk '{{OFS=";"};print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}'
	-- lsblk -n -o NAME,PATH,TYPE,SIZE,HOTPLUG,MODEL,MOUNTPOINT,FSTYPE,FSSIZE,FSAVAIL,FSUSED | tr -s ' '
	local file = io.popen("lsblk -n -o KNAME,PATH,TYPE,SIZE,HOTPLUG,MODEL,FSTYPE,MOUNTPOINT,FSSIZE,FSAVAIL,FSUSED | tr -s ' '")
	local result = file:read("*a")
	file:close()
	local linesArray
	linesArray = explode(result, '[\n\r]+')

	listresult = ""
	for index,value in pairs(linesArray) do
		if(value ~= "") then
			colsArray = explode(value, ' ')
			local name = colsArray[1]
			local path = colsArray[2]
			local type = colsArray[3]
			local size = colsArray[4]
			local hotplug = colsArray[5]:gsub("%s+", "")
			
			if(type == "disk") then
				local model = colsArray[6]
				local deviceIcon = (hotplug == "1") and "${offset 0}${color1}${font FontAwesome:size=11} ${font}" or "${offset 5}${color1}${font FontAwesome:size=11} ${font}"
				listresult = listresult..""..deviceIcon.." ${color1}${font}${font FontAwesome:size=11} ${font}${font DejaVu Sans:size=9}${color}${execi 8 hddtemp "..path.." 2>/dev/null | rev | cut -d ' ' -f 1 | rev}"
				listresult = listresult.." | ${diskio "..path.."}/s\n"
			elseif(type == "part") then
				local filesystemType = colsArray[6]
				local mountPoint = colsArray[7]
		
				if(not isEmpty(mountPoint)) then
					local filesystemType = colsArray[7]
					local filesystemSize = colsArray[8]
					
					if(not isEmpty(filesystemSize)) then
					    local filesystemAvailable = colsArray[9]
					    local filesystemUsed = colsArray[10]
					    
					    listresult = listresult.."${if_mounted "..mountPoint.."}${offset 22}${color1}${font DejaVu Sans:size=9}"..name.."${color} "..mountPoint.."${voffset 2}${font}\n"
					    listresult = listresult.."${font DejaVu Sans:size=9}${offset 22}"..filesystemAvailable.." / "..filesystemSize.."${font}${voffset 4}\n"
					    listresult = listresult.."${offset 22}${voffset -7}${fs_bar 4,175 "..mountPoint.."}${endif}\n"
					
					end
					
				end
			end
		end
	end
	return listresult
end

--print(conky_disk())
