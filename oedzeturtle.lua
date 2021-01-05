os.loadAPI("turtle_loc_man.lua")

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

function findFirstInContainer(refLocation, itemName)
    local items, count = findInContainer(refLocation, itemName)
    if count == 0 then
        return nil
    end
    for slot, amount in pairs(items) do
        return slot, amount
    end
end

function getOpositeName(refLocation)
    if refLocation == "front" then refLocation = turtle.getDirectionName(_location.direction) end
    if refLocation == "right" then refLocation = turtle.getDirectionName(_location.direction + 1) end
    if refLocation == "back" then refLocation = turtle.getDirectionName(_location.direction + 2) end
    if refLocation == "left" then refLocation = turtle.getDirectionName(_location.direction + 3) end
    if refLocation == "north" then return "south" end
    if refLocation == "east" then return "west" end
    if refLocation == "south" then return "north" end
    if refLocation == "west" then return "east" end
    if refLocation == "top" then return "down" end
    if refLocation == "bottom" then return "up" end
end

function pullItems(refLocation, fromSlot, ammount, toSlot)
    local inventory = peripheral.wrap(refLocation)
    --print("inventory: "..inventory)
    inventory.pushItems(getOpositeName(refLocation), fromSlot, ammount, toSlot)
end

function pushItems(refLocation, fromSlot, ammount, toSlot)
    local inventory = peripheral.wrap(refLocation)
    --print("inventory: "..inventory)
    inventory.pullItems(getOpositeName(refLocation), fromSlot, ammount, toSlot)
end

function dumpAll(refLocation)
    for slot= 1,16 do
        turtle.select(slot)
        local count = turtle.getItemCount()
        if count > 0 then
            pushItems(refLocation, slot, nil, nil)
        end
    end
end

function getItemFromInventory(refLocation, itemName, amount, return_slot)
    slot, count = oedzeturtle.findFirstInContainer(refLocation, itemName)
    if not slot then
        return false
    end
    oedzeturtle.pullItems(refLocation, slot, amount, return_slot)
    return true
end
