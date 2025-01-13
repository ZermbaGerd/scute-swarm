--[[
    This will run everytime we turn the computer on. That includes:
    when we log into the world, when we turn on the computer, when 
    the computer gets reloaded from an unloaded chunk.
]]

local smartMine = require("smartMine")
local smartCraft = require("smartCraft")
local calibration = require("calibration")
local smartActions = require("smartActions")
-- this will be used more extensively eventually, but it's just a placeholder for now


-- ALL THE CALIBRATION TO START WITH
calibration.setY()

while true do
    while not smartActions.isResourceSatisfied("minecraft:diamond") do
        smartMine.mineForBasicOre("diamonds")
    end
    while not smartActions.isResourceSatisfied("minecraft:redstone") do
        smartMine.mineForBasicOre("redstone")
    end
    while not smartActions.isResourceSatisfied("minecraft:lapis_lazuli") do
        smartMine.mineForBasicOre("lapis")
    end
    while not smartActions.isResourceSatisfied("minecraft:raw_iron") do
        smartMine.mineForBasicOre("iron")
    end
    while not smartActions.isResourceSatisfied("minecraft:sand") do
        smartMine.mineForBasicOre("sand")
    end

    smartCraft.growPlants()
    smartActions.smartDump()
    smartCraft.completeCraftingProcess()
end


-- Add a calibrater, and run this here:
    -- loads settings, reselects item slot, checks fuel, checks inventory
    -- if y not set, might immediately go try to set y
    -- if not have the items it always expects to have, maybe complains
        -- maybe needs to check around for disk drive and stuff beforehand