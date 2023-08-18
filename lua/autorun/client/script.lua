function getRandomPage(total)
	local pages = math.floor(total / 30)
	return math.random(0, pages)
end

function getMapName(file)
	return string.sub(file, 6, string.len(file) - 4)
end

function findMapFile(files)
	for key,value in pairs(files) do
		if (string.find(value, ".bsp")) then
			return value
		end
	end
	return nil
end

function installMod(id)
	steamworks.DownloadUGC(id, function( path, file )
		success, files = game.MountGMA(path)
		if (success) then
			local file = findMapFile(files)
			if (file) then 
				RunConsoleCommand("changelevel", getMapName(file))
			end
		end
	end)
end

concommand.Add("randommap", function()
	local tags = { "Map" }
	steamworks.GetList( "popular", tags, 0, 1, 0, 0, function( info ) 
		local page = getRandomPage(info.totalresults)
		steamworks.GetList( "popular", tags, page, 30, 0, 0, function( data )
			if (data.numresults > 0) then
				installMod(data.results[math.random(0, data.numresults )])
			end
		end )
	end )
end )