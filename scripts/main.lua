--[[
    This will run everytime we turn the computer on. That includes:
    when we log into the world, when we turn on the computer, when 
    the computer gets reloaded from an unloaded chunk.
]]

local smartMine = require("smartMine")
local smartCraft = require("smartCraft")
local calibration = require("calibration")
local smartActions = require("smartActions")


--[[
    Print messages for user to see if they forgot to give an item to the turtle
]]
local needItem = false
if smartActions.countItem("minecraft:chest") < 1 then
    print("Need a chest")
    needItem = true
end
if smartActions.countItem("minecraft:sugarcane") < 1 then
    print("Need a piece of sugarcane")
    needItem = true
end
if smartActions.countItem("minecraft:birch_sapling") < 2 then
    print("Need at least 2 birch saplings")
    needItem = true
end
if smartActions.countItem("minecraft:bucket") < 1 and smartActions.countItem("minecraft:lava_bucket") < 1 then
    print("Need a bucket or a lava bucket. If this is the first time starting, this needs a lava bucket")
    needItem = true
end

if needItem == true then
    os.sleep(5)
end


-- Start by checking for Y/calibrating Y

local calibrated = calibration.checkForY()
-- the only time we're not calibrated is if we were just invented, so we can safely refuel and calibrate
if not calibrated then
    if not smartActions.hasEnoughFuel() then
        smartActions.selectItem("minecraft:lava_bucket")
        turtle.refuel()
    end
    calibration.calibrateY()
end


--[[
    The loop logic for this is pretty simple:
        - when we start the loop we see if we have enough fuel
            - if we don't, we immediately go gather more fuel
        - if we DO have enough fuel, we go down the list of resources we need and gather them
            - each of these "gathering" (mineForBasic and growPlants) will automatically exit if we fall below acceptable fuel levels
            - which will start us back into the while loop to refuel
]]
while true do
    if smartActions.hasEnoughFuel() then
        print("had enough fuel in main loop")
        if not smartActions.isResourceSatisfied("minecraft:diamond") then
            smartMine.mineForBasicOre("diamonds")
        
        elseif not smartActions.isResourceSatisfied("minecraft:redstone") then
            smartMine.mineForBasicOre("redstone")
        
        elseif not smartActions.isResourceSatisfied("minecraft:lapis_lazuli") then
            smartMine.mineForBasicOre("lapis")
        
        elseif not smartActions.isResourceSatisfied("minecraft:raw_iron") then
            smartMine.mineForBasicOre("iron")
        
        elseif not smartActions.isResourceSatisfied("minecraft:sand") then
            smartMine.mineForBasicOre("sand")
        
        elseif not smartActions.isResourceSatisfied("minecraft:birch_sapling") or 
                not smartActions.isResourceSatisfied("minecraft:birch_log") then
            smartCraft.growPlants()
        else
            -- if all of our resources are satisfied, and we have enough fuel, do the crafting process
            smartActions.smartDump()
            smartCraft.completeCraftingProcess()
        end
    else
        print("didn't have enough fuel in main loop")
        -- if(smartActions.selectItem("minecraft:lava_bucket")) then
        --     turtle.refuel()
        -- end
        smartMine.mineForBasicOre("fuel")
    end
end