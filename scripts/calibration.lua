local calibration = {}

-- if calibration requires smac, and smac requires calibration, everything breaks
-- which means we can't use samc helper functions here

-- meaning smac probably ends up being a "higher-level" helper library

local function goToBedrock() 
    local foundBedrock = false

    while not foundBedrock do 
        -- check if the block below us is bedrock, if it is, break and return
        local has_block, block_data = turtle.inspectDown()
        if has_block then 
            if block_data["name"] == "minecraft:bedrock" then
                foundBedrock = true
                return true
            end

            -- if the block isn't bedrock, mine it to clear our path
            turtle.digDown()
            -- this used to be smac. think if we need more edge-case handling that smac provides
            -- if we do, we'll need to change it up a bit

        end
        
        -- move down one block
        turtle.down()
    end
end


-- checks whether the given block is next to the turtle
-- returns a boolean value, as well as a table with the particular positions the block was in
local function checkBedrockInFront()
    local has_block, details = turtle.inspect()
    if (has_block and details["name"] == "minecraft:bedrock") then
        return true
    end
    return false
end

-- Returns the turtle to its original space in the bedrock search, maintaining its original orientation
local function returnToStart(offset, angle)
    if angle == "left" then
        turtle.turnRight()
    end
    if angle == "right" then
        turtle.turnLeft()
    end
    for i = 1,offset do
        turtle.back()
    end
end

local function checkStillInBedrock()
    local offset = 0
    local angle = "forward"

    for i=1,4 do
        for i=1,2 do 
            local success, reason = turtle.dig()
            if success or reason == "Nothing to dig here" then
                turtle.forward()
                offset = offset + 1
            end
            
            turtle.turnLeft()
            if checkBedrockInFront() then
                returnToStart(offset, "left")
                return true
            end
            turtle.turnRight()
            turtle.turnRight()
            if checkBedrockInFront() then
                returnToStart(offset, "right")
                return true
            end
            turtle.turnLeft()
            if checkBedrockInFront() then
                returnToStart(offset, "forward")
                return true
            end
        end
        turtle.back()
        turtle.back()
        turtle.turnRight()
    end
    return false
end



local function goToTopOfBedrock()
    --[[
    When we hit bedrock, there's only a 1 in 5 chance we're at the lowest comfortable y-level
    This function calibrates us to be at the top of bedrock. It first checks whether there is any bedrock next to it, moving up and repeating if there is.
    If there isn't bedrock directly next to it, it goes out two blocks in each direction, checking for bedrock as it does. If it sees bedrock there, it goes up again and repeats.
    ]]
    for i = 1,4 do
        if checkBedrockInFront() then
            turtle.digUp()
            turtle.up()
            goToTopOfBedrock()
            return
        end
        turtle.turnRight()
    end
    if checkStillInBedrock() then
        turtle.digUp()
        turtle.up()
        goToTopOfBedrock()
        return
    end
    return
end

-- Places the turtle one layer above bedrock, and sets its internal y to -59. Main function to use
-- if the y-value in settings isn't set yet, or if we run into some other problem that happens because
-- of uncalibrated y-values
function calibration.calibrateY()
    goToBedrock()
    goToTopOfBedrock()

    -- this used to be smac.setY, but that breaks, so doing it ourselves
    -- need to think about whether settings is already loaded, etc.

    settings.load()
    settings.set("yLevel", -59)
    settings.save()

    return true
end

-- Checks if we already have a saved y-value.
function calibration.checkForY()
    settings.load()
    if settings.get("yLevel") ~= nil then
        return true
    else
        return false
    end
end


-- did set y alr :)

-- TODO:

-- CHECK INVENTORY / UPDATE REQUIRED MATERIALS type beat
-- CHECK FUEL / INITIAL REFUEL

-- Return the module
-------------------+
return calibration
-------------------+