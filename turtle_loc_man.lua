--Turtle location manager by oedze
local _settingsFolder = "./.oedzeturtle"
local _locationFolder = _settingsFolder .. "/location"

if turtle.tlm_loaded then
    print("turtle location manager was already loaded, skipping init")
    return
end

local _directionNames = {"north", "east", "south", "west"}
--Direction, 0 = NOrth, 1 = East, 2 = Sout, 3= West
local _location = {
    x = 0,
    y = 0,
    z = 0,
    direction = 0
}

local function saveLocation()
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



if not fs.exists(_settingsFolder) then
    fs.makeDir(_settingsFolder)
else
    --print("Dir exists")
end




local oldTurnLeft = turtle.turnLeft
local oldTurnRight = turtle.turnRight
local oldUp = turtle.up
local oldDown = turtle.down
local oldForward = turtle.forward
local oldBack = turtle.back

local function mutateLocation(localForwardDiff, localYDiff, localRotation)
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
    if _location.direction == 3 then
        --print("Negative x")
        _location.x = _location.x - localForwardDiff
    end
    saveLocation()
end


local function forward()
    local success = oldForward()
    if success then mutateLocation(1, 0, 0) end
    return success
end

local function back()
    local success = oldBack()
    if success then mutateLocation(-1, 0, 0) end
    return success
end

local function up()
    local success = oldUp()
    if success then mutateLocation(0, 1, 0) end
    return success
end

local function down()
    local success = oldDown()
    if success then mutateLocation(0, -1, 0) end
    return success
end

local function turnRight()
    oldTurnRight()
    mutateLocation(0, 0, 1)
    return success
end

local function turnLeft()
    oldTurnLeft()
    mutateLocation(0, 0, -1)
    return success
end

local function getLocation ()
    return _location
end

local function getDirectionName(direction)
    if direction > 3 then direction = direction - 4 end
    if direction < 0 then direction = direction + 4 end
    return _directionNames[direction + 1]
end

local function setLocation(location)
    _location = location
    saveLocation()
end

local _tempLocation = {
    x = nil,
    y = nil,
    z = nil,
    direction = nil
}
local function validateLocation()
    x, y, z = gps.locate()
    if x == nil then
        return nil
    end
    _tempLocation.x = x
    _tempLocation.y = y
    _tempLocation.z = z
    _tempLocation.direction = 0 --Unknown

    local turtleLocation = getLocation()

    if turtleLocation.x == x and turtleLocation.y == y and turtleLocation.z == z then
        --assume direction is right
        return false
    else
        setLocation(_tempLocation)
        return true
    end

end


local function getDirection(xDiff, zDiff)
    if xDiff > 0 then
        return 1 --East
    end
    if xDiff < 0 then
        return 3  --West
    end
    if(zDiff > 0) then
        return 2 --South
    end

    if(zDiff < 0) then
        return 0 --North
    end
    return nil
end

local function findDirection()
    local curX, curY, curZ = gps.locate()
    if(curX == nil) then
        return false
    end

    local rotated = 0

    local found = false
    local turtleDirection = 0
    while found == false and rotated < 4 do
        if oldForward() then
            found = true
            local newX, newY, newZ = gps.locate()
            oldBack()
            turtleDirection = getDirection(newX - curX, newZ - curZ)
        else
            oldTurnRight()
            rotated = rotated + 1
        end
    end

    for rot =  1, rotated do
        oldTurnLeft()
    end
    return (turtleDirection - rotated) % 4

end

local function storePositionAndDirection()
    local updated = validateLocation()
    if(updated == true) then
        _location.direction = findDirection()
        saveLocation()
    end

end
function validateDirection()
    _location.direction = findDirection()
    saveLocation()
end

turtle.turnLeft = turnLeft
turtle.turnRight = turnRight
turtle.down = down
turtle.up = up
turtle.forward = forward
turtle.back = back

turtle.getDirectionName = getDirectionName
turtle.getLocation = getLocation
turtle.setLocation = setLocation
turtle.validateLocation = storeLocation
turtle.validateDirection = validateDirection
turtle.validateLocationAndRotation = storePositionAndDirection


turtle.tlm_loaded = true

