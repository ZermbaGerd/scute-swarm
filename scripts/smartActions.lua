local smartActions = {}

-- TODO - figure out whether requires within modules breaks stuff. does it make programs that require this run it too?
local calibration = require("calibration")
local globals = require("globals")

-- TODO move this to startup function/module
settings.load()

--[[
    ABBREVIATIONS
]]

function smartActions.dig() return smartActions.smartDig() end
function smartActions.digUp() return smartActions.smartDigUp() end
function smartActions.digDown() return smartActions.smartDigDown() end

function smartActions.up() return smartActions.smartUp() end
function smartActions.down() return smartActions.smartDown() end

function smartActions.sy() return smartActions.setY() end
function smartActions.gy() return smartActions.getY() end



--[[
    ACTUAL FUNCTIONS
]]


    --[[        MINING FUNCTIONS        ]]--


--[[
    Digs forward, digging extra blocks if they exist. These are likely gravel/sand. Also avoids 
    blocks on a pre-determined disallowed mining list. These would probably be chests/disk drives/turtles.
    If we want to have circumstances where we mine without moving into the slot we're mining,
    we may need to adjust this to account for accidental cobblestone generators

    Return: a success value, a reason for any failure or extra action
]]
function smartActions.smartDig()
    local dug, reason = turtle.dig()

    if dug then
        -- if we broke a block, check if there's another block
        local is_block = turtle.detect()

        -- if there is, we'll clear it by just digging until no block remains
        if is_block then
            reason = "Had to clear extra blocks"
        end

        while is_block do
            turtle.dig()
            is_block = turtle.detect()
        end
    end

    return dug, reason
end

-- Version of smart dig to dig up
function smartActions.smartDigUp()
    local dug, reason = turtle.digUp()

    if dug then
        -- if we broke a block, check if there's another block
        local is_block = turtle.detectUp()

        -- if there is, we'll clear it by just digging until no block remains
        if is_block then
            reason = "Had to clear extra blocks"
        end

        while is_block do
            turtle.digUp()
            is_block = turtle.detectUp()
        end
    end

    return dug, reason
end

-- Version of smart dig to dig down
function smartActions.smartDigDown()
    local dug, reason = turtle.digDown()

    if dug then
        -- if we broke a block, check if there's another block
        local is_block = turtle.detectDown()

        -- if there is, we'll clear it by just digging until no block remains
        if is_block then
            reason = "Had to clear extra blocks"
        end

        while is_block do
            turtle.digDown()
            is_block = turtle.detectDown()
        end
    end

    return dug, reason
end

-- Helper function for mineLayer, mines just one row and ends where it started
function smartActions.mineRow(width)
    for i=1,2 do
        for i=1,width-1 do
            smartActions.goForward()
        end
        smartActions.turn180()
    end
end

-- Helper function for minePrism, mines just one layer :)
function smartActions.mineLayer(width)
    for i=1,width-1 do
        smartActions.mineRow(width)
        turtle.turnRight()
        smartActions.goForward()
        turtle.turnLeft()
    end
    smartActions.mineRow(width)
end


--[[
    Mines a square shape of given width and height. Ends by returning to its original position. Also takes in a position. 
    The valid positions are 'top' for the top left corner of the prism and 'bottom' for the bottom left corner of the prism
]]
function smartActions.minePrism(width, height, position)
    if position ~= "top" and position ~= "bottom" then
        print("incorrect position passed to minePrism")
        return false
    end

    for i=1,height do

        -- mine layer
        smartActions.mineLayer(width)
        turtle.turnLeft()

        -- return to start corner
        for i=1,width-1 do
            smartActions.goForward()
        end
        turtle.turnRight()

        -- adjust height according to position
        if position == "top" then
            smartActions.goDown()   -- TODO: fix this - technically this mines one block in the corner above/below the prism too :/
        else
            smartActions.goUp()
        end
    end

    for i=1, height do
        if position == "top" then
            smartActions.goUp()
        else
            smartActions.goDown()
        end
    end
end



    --[[        MOVEMENT FUNCTIONS      ]]--


-- Version of turtle.up() that updates the y-value too
function smartActions.moveUp()
    -- TODO, when we have calibration and can check if settings are loaded or not, might adjust

    local success, reason = turtle.up()

    if success then
        smartActions.setY(smartActions.getY() + 1)
        return success, reason
    end

    return success, reason
end

-- Version of turtle.down() that updates the y-value too
function smartActions.moveDown()

    local success, reason = turtle.down()

    if success then
        smartActions.setY(smartActions.getY() - 1)
        return success, reason
    end
    return success, reason
end

-- Goes forward, breaking blocks in front of it if necessary
function smartActions.goForward()
    local moveSuccess, moveReason = turtle.forward()
    if moveSuccess then return true end
    
    local digSuccess, digReason = smartActions.dig()
    if not digSuccess then
        print(" SHIT IS REALLY BROKEN SHIT IS REALLY BROKEN")
        print(digReason)
        return false
    end

    moveSuccess, moveReason = turtle.forward()
    return moveSuccess
end

-- Goes up, smartly breaking blocks if necessary
function smartActions.goUp()
    local moveSuccess, moveReason = smartActions.moveUp()
    if moveSuccess then return true end
    
    local digSuccess, digReason = smartActions.digUp()
    if not digSuccess then
        print(" SHIT IS REALLY BROKEN SHIT IS REALLY BROKEN")
        print(digReason)
        return false
    end

    moveSuccess, moveReason = smartActions.moveUp()
    return moveSuccess
end

-- Goes down, smartly breaking blocks if necessary
function smartActions.goDown()
    local moveSuccess, moveReason = smartActions.moveDown()
    if moveSuccess then return true end
    
    local digSuccess, digReason = smartActions.digDown()
    if not digSuccess then
        print(" SHIT IS REALLY BROKEN SHIT IS REALLY BROKEN")
        print(digReason)
        return false
    end

    moveSuccess, moveReason = smartActions.moveDown()
    return moveSuccess
end

-- goes backwards, maintaining orientation after function call and smartly breaking blocks if necessary
function smartActions.goBackward()
    smartActions.turn180()
    smartActions.goForward()
    smartActions.turn180()
end

-- turns the turtle 180 degrees. Not complicated, but makes other code more readable.
function smartActions.turn180()
    turtle.turnRight()
    turtle.turnRight()
end


-- Goes to a y value, breaking blocks if necessary
function smartActions.goToY(desiredY)
    local CurrentY = smartActions.getY()

    if CurrentY == desiredY then return true end

    while CurrentY ~= desiredY do
        if CurrentY < desiredY then
            smartActions.goUp()
            CurrentY = CurrentY + 1
        else
            smartActions.goDown()
            CurrentY = CurrentY - 1
        end
    end
end



    --[[        INVENTORY FUNCTIONS        ]]--

--[[
    Checks whether an item is in the turtle's inventory. Parameter needs to be a string perfectly matching the item's
    Minecraft name. If the item is in the inventory, it returns a slot containing that item (if there are multiple, it only returns one of them)
    Returns bool, and slot (false & nil if no slot)
]]
function smartActions.checkInventoryForItem(itemName)
    local success = false
    local foundSlot = nil
    for i=1,16 do
        print(i)
        local itemDetails = turtle.getItemDetail(i)
        if itemDetails ~= nil then
            if itemDetails["name"] == itemName then
                success = true
                foundSlot = i
            end
        end
    end

    if not success then return success
    else return {success, foundSlot} end
end

--[[
    If an item is in the inventory, selects the last inventory slot with that item in it.
]]
function smartActions.selectItem(itemName)
    local checkResult = smartActions.checkInventoryForItem(itemName)
    if checkResult == false then
        return false
    end
    turtle.select(checkResult[2])
    return true
end

--[[
    Conglomerates all items into their maximum stack. The lowest index will end with the largest stack. If there are
    enough items for multiple slots to be filled, those slots are not guaranteed to be side-by-side, but the bigger stack
    is guaranteed to be the lower index (closer to top left)
]]
function smartActions.gatherItems()
    local firstSlot = turtle.getSelectedSlot()

    -- remembers the last slot we saw for each item
    local seenSlots = {}
    for i = 1,16 do
        turtle.select(i)
        local itemDetails = turtle.getItemDetail(i)
        if itemDetails ~= nil then
        -- if there's an item at this slot

            if seenSlots[itemDetails["name"]] == nil then
            -- if we haven't seen the item yet, mark that slot as the last time we saw that item
                seenSlots[itemDetails["name"]] = i
            
            else
            -- otherwise, try to transfer items to that slot, and check if there are any remaining in current
            -- if there are, then mark this slot as the last time we saw that item
                turtle.transferTo(seenSlots[itemDetails["name"]])

                -- check if items are remaining, if so, update seenSlot accordingly
                itemDetails = turtle.getItemDetail(i)
                if itemDetails ~= nil then
                    seenSlots[itemDetails["name"]] = i
                end
            end
        end
    end
    turtle.select(firstSlot)
end


--[[
    Gathers items into stacks, then dumps all non-whitelisted items, as well as the smaller stack of 
    any whitelisted items that have gone over a stack.
]]
function smartActions.smartDump()
    smartActions.gatherItems()
    smartActions.dumpItems()
end

--[[
    Drops all items that are not whitelisted items. Keeps at most one full stack/slot of whitelisted items. The list 
    of whitelisted itemsis defined at the top of this function.
]]
function smartActions.dumpItems()
    -- TODO: figure out how to handle processed versions of this. for instance if we have floppy already, we never need lapis again

    local startSlot = turtle.getSelectedSlot()
    local seen = {}

    for i=1,16 do
        local itemDetails = turtle.getItemDetail(i)
        -- if there's an item in the slot
        if itemDetails ~= nil then
            -- if the item's name is not in the list of whitelisted items then drop it
            if globals.whitelisted[itemDetails["name"]] == nil then  
                turtle.select(i)
                turtle.drop()
            
            else
                -- if this is the first time we see a slot with this item in it, mark that
                if seen[itemDetails["name"]] == nil then
                    seen[itemDetails["name"]] = true
                
                -- if this is not the first time we see a slot with this item in it, drop that slot
                else
                    turtle.select(i)
                    turtle.drop()
                end
            end 
        end
    end

    turtle.select(startSlot)
end


--[[
    Counts how many of a given item the turtle has in its inventory. Expects to receive the entire item name,
    including the "minecraft:" part.
]]
function smartActions.countItem(itemName)
    local count = 0
    for i=1,16 do
        local itemDetails = turtle.getItemDetail(i)
        if itemDetails ~= nil then
            if itemDetails["name"] == itemName then
                count = count + turtle.getItemCount(i)
            end
        end
    end
    return count
end

--[[
    Checks whether we have enough of the given resource to satisfy our resources.
    If we pass a resource name that isn't in the list, it returns false.
    Expects to receive the entire item name, including the "minecraft:" part
]]
function smartActions.isResourceSatisfied(resource_name)
    local count = 0
    -- if the item isn't in resources, return false
    if globals.resourceCount[resource_name] == nil then
        return false
    else
        count = smartActions.countItem(resource_name)
    end

    -- return whether that count is at least the required amount
    return count >= globals.resourceCount[resource_name]
end


        --[[    CALIBRATION FUNCTIONS       ]]--

-- Returns true if the turtle's current fuel level is above its minimum limit, false if it isn't
function smartActions.hasEnoughFuel()
    local fuelAmount = turtle.getFuelLevel()
    if fuelAmount == "unlimited" then
        return true
    end

    if fuelAmount < globals.minimumFuel then
        return false
    end

    return true
end

-- sets the turtle's internal y value to a value. Expects settings to be loaded already
-- Should break if setting to nil, probably
function smartActions.setY(yValue)
    if yValue == nil then
        print("tried to set y-value to nil")
        print("so we did nothing")
    end
    settings.set("yLevel", yValue)
    settings.save()
end

-- returns the turtle's internal y level
-- currently, returns false if it isn't set yet.
function smartActions.getY()
    local y = settings.get("yLevel")

    if y == nil then 
        return false
    end

    return y
end



-- Return the module! --+
return smartActions   --+
------------------------+