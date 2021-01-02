os.loadAPI('path')
local settingsFolder = "./oedzeturtle"
local locationFolder = path.combine(settingsFolder, "location")

--Direction, 0 = NOrth, 1 = East, 2 = Sout, 3= West
local defaultLocation = {
    x = 0,
    y = 0,
    z = 0,
    direction = 0 -- North, east, south, west
}

local location

if not fs.exists(settingsFolder) then
    fs.makeDir(settingsFolder)
end

function saveLocation()
    fs.open(locationFolder, "w")
    fs.write(textutils.serialize(location))
    fs.close()
end

if not fs.exists(path.combine(locationFolder)) then
    location = defaultLocation
    saveLocation()
end



