os.loadAPI('path.lua')
_settingsFolder = "./.oedzeturtle"
_locationFolder = path.combine(_settingsFolder, "location")


_directionNames = {"north", "east", "south", "west"}
--Direction, 0 = NOrth, 1 = East, 2 = Sout, 3= West
_location = {
    x = 0,
    y = 0,
    z = 0,
    direction = 0
}

if not fs.exists(_settingsFolder) then
    fs.makeDir(_settingsFolder)
else
    --print("Dir exists")
end

function saveLocation()
    local file = fs.open(_locationFolder, "w")
    file.write(textutils.serialize(_location))
    file.close()
end

if fs.exists(_locationFolder) then
    --print("locationfolder exists, getting location....")
    local file = fs.open(_locationFolder, "r")
    local x = file.readAll()
    --print("x", x)
    _location = textutils.unserialize(x)
    --print("Location: ", location)
    file.close()
else
    --print("Locationfolder doensn't exists, creatingz    ")
    saveLocation()
end


function findInOwnSlot(name)
    currentSlot = turtle.getSelectedSlot()
    returnSlots = {}
    count = 0
    for i=1,16 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item == nil then
            --Do nothing
        elseif name == item.name then
            returnSlots[i] = item.count
            count = count + item.count
        end
    end
    turtle.select(currentSlot)
    return returnSlots, count
end

function findInContainer(refLocation, itemName)
    local returnSlots = {}
    local count = 0
    local container = peripheral.wrap(refLocation)
    for slot, item in pairs(container.list()) do
        if(item.name == itemName) then
            returnSlots[slot] = item.count
            count = count + item.count
        end
    end
    return returnSlots, count
end

function mutateLocation(localForwardDiff, localYDiff, localRotation)
    --//print("Mutation: [" .. localForwardDiff .. ", " .. localYDiff .. ", " .. localRotation .. "]")
    _location.direction = _location.direction + localRotation
    if(_location.direction > 3) then _location.direction = _location.direction - 4 end
    if(_location.direction < 0) then _location.direction = _location.direction + 4 end
    _location.y = _location.y + localYDiff
    if _location.direction == 0 then
        --//print("Negative z")
        _location.z = _location.z - localForwardDiff
    end
    if _location.direction == 1 then
        --//print("Positive x")
        _location.x = _location.x + localForwardDiff
    end
    if _location.direction == 2 then
        --//print("Positive z")
        _location.z = _location.z + localForwardDiff
    end
    if _location.direction == 1 then
        --print("Negative x")
        _location.x = _location.x - localForwardDiff
    end
end


function forward()
    local success = turtle.forward()
    if success then mutateLocation(1, 0, 0) end
end

function back()
    local success = turtle.back()
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

function getDirectionName(direction)
    if direction > 3 then direction = direction - 4 end
    if direction < 0 then direction = direction + 4 end
    return _directionNames[direction + 1]
end

function getOpositeName(refLocation)
    if refLocation == "front" then refLocation = getDirectionName(_location.direction) end
    if refLocation == "right" then refLocation = getDirectionName(_location.direction + 1) end
    if refLocation == "back" then refLocation = getDirectionName(_location.direction + 2) end
    if refLocation == "left" then refLocation = getDirectionName(_location.direction + 3) end
    if refLocation == "north" then return "south" end
    if refLocation == "east" then return "west" end
    if refLocation == "south" then return "north" end
    if refLocation == "west" then return "east" end
    if refLocation == "up" then return "bottom" end
    if refLocation == "bottom" then return "up" end
end

function pullItems(refLocation, fromSlot, ammount, toSlot)
    inventory = peripheral.wrap(refLocation)
    --print("inventory: "..inventory)
    inventory.pushItems(getOpositeName(refLocation), fromSlot, ammount, toSlot)
end

function pushItems(refLocation, fromSlot, ammount, toSlot)
    inventory = peripheral.wrap(refLocation)
    --print("inventory: "..inventory)
    inventory.pullItems(getOpositeName(refLocation), fromSlot, ammount, toSlot)
end

