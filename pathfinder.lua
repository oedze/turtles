
directions = {
    north = 0, --Negativez
    east = 1, --PostiveX
    south = 2, --PostiveZ
    west = 3 --NegativeX
}

local function turnTo(targetDirection)
    targetDirection = targetDirection % 4
    local startDirection = turtle.getLocation().direction
    --0 for nothing, -1 for left, 1 for right
    local rotating = 0
    local diff = targetDirection - startDirection
    if diff == 0 then
        rotating = 0 --Dont rotate
    elseif(diff > 2 or diff < 0) then
        rotating = -1
    elseif(diff <=2) then
        rotating = 1
    end

    if rotating > 0 then
        while(startDirection ~= targetDirection) do
            turtle.turnRight()
            startDirection = (startDirection + 1) % 4
        end
    elseif rotating < 0 then
        while(startDirection ~= targetDirection) do
            turtle.turnLeft()
            startDirection = (startDirection - 1) % 4
        end
    end

end

local function moveForward(steps)
    for step=1, math.abs(steps) do
        while not turtle.forward() do

        end
    end
end


local function moveBackward(steps)
    for step=1, math.abs(steps) do
        while not turtle.back() do

        end
    end
end

--Moving relative
function moveX(xSteps, backwards)
    if( backwards == nil) then
        backwards = false
    end
    local gotoDirection = 0
    if(xSteps > 0) then
        gotoDirection = directions.east
    elseif(xSteps < 0) then
        gotoDirection = directions.west
    end
    if backwards then
        gotoDirection = gotoDirection + 2
    end

    if(backwards) then print("moving backwards") else print("moving forward") end

    turnTo(gotoDirection)

    if(backwards) then
        moveBackward(xSteps)
    else
        moveForward(xSteps)
    end
end


function moveZ(zSteps, backwards)
    if( backwards == nil) then
        backwards = false
    end
    local gotoDirection = 0
    if(zSteps > 0) then
        gotoDirection = directions.south
    elseif(zSteps < 0) then
        gotoDirection = directions.north
    end
    if backwards then
        gotoDirection = gotoDirection + 2
    end

    turnTo(gotoDirection)

    if(backwards) then
        moveBackward(zSteps)
    else
        moveForward(zSteps)
    end
end

function moveY(ySteps)
    if(ySteps > 0) then
        for step = 1, math.abs(ySteps) do
            while not turtle.up() do end
        end
    end

    if(ySteps < 0) then
        for step = 1, math.abs(ySteps) do
            while not turtle.down() do end
        end
    end
end


--Moving to absolute
function gotoX(xCoord)
    local currentX = turtle.getLocation().x
    local diff = xCoord - currentX
    moveX(diff)
end

function gotoZ(zCoord)
    local currentZ = turtle.getLocation().z
    local diff = zCoord - currentZ
    moveZ(diff)
end

function gotoY(yCoord)
    local currentY = turtle.getLocation().y
    local diff = yCoord - currentY
    moveY(diff)
end


function goto(x, y, z, order, direction)
    if not x or not y or not z or not order then
        error("missing parameters, use : <x> <y> <z> <order> [direction]")
    end
    if #order ~= 3 then
        print("order paramter shoul container only x, y, or z, each one")
    end

    for i=1,#order do
        local direction = order:sub(i, i)
        if(direction == "x") then
            gotoX(x)
        elseif(direction == "y") then
            gotoY(y)
        elseif(direction == "z") then
            gotoZ(z)
        else
            error("unknown order type, only x, y, or z allowed")
        end
    end

    if direction then turnTo(direction) end

end
