--[[
    This will run everytime we turn the computer on. That includes:
    when we log into the world, when we turn on the computer, when 
    the computer gets reloaded from an unloaded chunk.
]]

local smartMine = require("smartMine")
local smartCraft = require("smartCraft")
local calibration = require("calibration")
local smartActions = require("smartActions")


-- ALL THE CALIBRATION TO START WITH
calibration.calibrate()


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
        smartMine.mineForBasicOre("fuel")
    end
end