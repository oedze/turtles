os.loadAPI('path.lua')
settingsFolder = "./oedzeturtle"
locationFolder = path.combine(settingsFolder, "location")

--Direction, 0 = NOrth, 1 = East, 2 = Sout, 3= West
location = {
    x = 0,
    y = 0,
    z = 0,
    direction = 0 -- North, east, south, west
}


if not fs.exists(settingsFolder) then
    fs.makeDir(settingsFolder)
end

function saveLocation()
    fs.open(locationFolder, "w")
    fs.write(textutils.serialize(location))
    fs.close()
end

if fs.exists(locationFolder) then
    local file = fs.open(locationFolder, "r")
    location = textutils.unserialize(file.readAll())
    file.close()
end

function mutateLocation(localForwardDiff, localYDiff, localRotation)
    location.rotation = location.rotation + localRotation
    if(location.rotation > 3) then location.rotation = 0 end
    if(location.rotation < 0) then location.rotation = 3 end
    location.y = location.y + localYDiff
    if location.direction == 0 then
        location.z = location.z - localForwardDiff
    end
    if location.direction == 1 then
        location.x = location.x + localForwardDiff
    end
    if location.direction == 2 then
        location.z = location.z + localForwardDiff
    end
    if location.direction == 1 then
        location.x = location.x - localForwardDiff
    end
end


function forward()
    local success = turtle.forward()
    if success then mutateLocation(1, 0, 0); end
end

function backward()
    local success = turtle.backward()
    if success then mutateLocation(-1, 0, 0) end
end

function up()
    local success = turtle.up()
    if success then mutateLocation(0, 1, 0) end
end

function down()
    local success = turtle.down()
    if success then mutateLocation(0, -1, 0) end
end

function turnRight()
    turtle.turnRight()
    mutateLocation(0, 0, 1)
end

function turnLeft()
    turtle.turnLeft()
    mutateLocation(0, 0, -1)
end

function getLocation ()
    return location
end



