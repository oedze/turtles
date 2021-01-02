os.loadAPI('path.lua')
settingsFolder = "./oedzeturtle"
locationFolder = path.combine(settingsFolder, "location")

--Direction, 0 = NOrth, 1 = East, 2 = Sout, 3= West
location = {
    x = 0,
    y = 0,
    z = 0,
    direction = 0
}

if not fs.exists(settingsFolder) then
    fs.makeDir(settingsFolder)
else
    print("Dir exists")
end

function saveLocation()
    local file = fs.open(locationFolder, "w")
    file.write(textutils.serialize(location))
    file.close()
end

if fs.exists(locationFolder) then
    print("locationfolder exists, getting location....")
    local file = fs.open(locationFolder, "r")
    local x = file.readAll()
    print("x", x)
    location = textutils.unserialize(file.readAll())
    print("Location: ", location)
    file.close()
else
    print("Locationfolder doensn't exists, closing")
    saveLocation()
end

function mutateLocation(localForwardDiff, localYDiff, localRotation)
    print("Mutation: [" .. localForwardDiff .. ", " .. localYDiff .. ", " .. localRotation .. "]")
    location.rotation = location.rotation + localRotation
    if(location.rotation > 3) then location.rotation = 0 end
    if(location.rotation < 0) then location.rotation = 3 end
    location.y = location.y + localYDiff
    if location.direction == 0 then
        print("Negative z")
        location.z = location.z - localForwardDiff
    end
    if location.direction == 1 then
        print("Positive x")
        location.x = location.x + localForwardDiff
    end
    if location.direction == 2 then
        print("Positive z")
        location.z = location.z + localForwardDiff
    end
    if location.direction == 1 then
        print("Negative x")
        location.x = location.x - localForwardDiff
    end
end


function forward()
    local success = turtle.forward()
    if success then mutateLocation(1, 0, 0) end
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



