---- DEFINE LIBRARY ----
local smartMine = {}
------------------------

local smac = require("smartActions")


--[[
    Digs in a straight line until it sees a block (in front, above, or below, but not left or right) 
    with either name1 or name2. These should be the regular ore and the deepslate version of the ore
]]
local function digUntilFind(name1, name2)
    local foundOre = false

    while not foundOre do
        local has_block, details = turtle.inspect()
        if has_block then
            if details["name"] == name1 or details["name"] == name2 then
                foundOre = true
                return true
            end
        end

        has_block, details = turtle.inspectUp()
        if has_block then
            if details["name"] == name1 or details["name"] == name2 then
                foundOre = true
                return true
            end
        end

        has_block, details = turtle.inspectDown()
        if has_block then
            if details["name"] == name1 or details["name"] == name2 then
                foundOre = true
                return true
            end
        end

        smac.goForward()
    end
end

--[[
    Goes to the y-level for an ore, and then mines in a straight line until it finds that resource.
    Once it finds that resource, it dumps its excess items and mines the whole vein.
]]
function smartMine.mineForBasicOre(ore)
    -- Y-levels to mine at are taken from https://minecraft.wiki/w/Ore#Distribution as of 11/4/24
    if ore == "diamond" or ore == "diamonds" then
        smac.goToY(-59)
        digUntilFind("minecraft:deepslate_diamond_ore", "minecraft:diamond_ore")
        smac.smartDump()
        smartMine.mineVein("minecraft:deepslate_diamond_ore")
        smartMine.mineVein("minecraft:diamond_ore")

    elseif ore == "redstone" then
        smac.goToY(-59)
        digUntilFind("minecraft:deepslate_redstone_ore", "minecraft:redstone_ore")
        smac.smartDump()
        smartMine.mineVein("minecraft:deepslate_redstone_ore")
        smartMine.mineVein("minecraft:redstone_ore")
    

    elseif ore == "lapis" or ore == "lapis lazuli" then
        smac.goToY(-2)
        digUntilFind("minecraft:deepslate_lapis_ore", "minecraft:lapis_ore")
        smac.smartDump()
        smartMine.mineVein("minecraft:deepslate_lapis_ore")
        smartMine.mineVein("minecraft:lapis_ore")


    elseif ore == "iron" then
        smac.goToY(14)
        digUntilFind("minecraft:deepslate_iron_ore", "minecraft:iron_ore")
        smac.smartDump()
        smartMine.mineVein("minecraft:deepslate_iron_ore")
        smartMine.mineVein("minecraft:iron_ore")
    

    elseif ore == "coal" or ore == "fuel" then
        smac.goToY(45)
        digUntilFind("minecraft:deepslate_coal_ore", "minecraft:coal_ore")
        smac.smartDump()
        smartMine.mineVein("minecraft:deepslate_coal_ore")
        smartMine.mineVein("minecraft:coal_ore")
    
    -- this is a temp way to find sand w/o sticking to a surface
    -- based on the idea that we mostly want sand to grow sugarcane on, so it will be at water level
    -- 62 for the y should keep us at the top block of rivers / oceans, so we are walking through water
    elseif ore == "sand" then
        smac.goToY(62)
        digUntilFind("minecraft:sand", "NONE")
        smac.smartDump()
        smac.minePrism(4,3,'top')
    
    else
        print("invalid ore option")
    end

end


--[[
    Recursively mines a vein of blocks with the given name. Checks every side of the current position for the block,
    and then, if there was a block there, goes to that spot and recursively repeats
]]
function smartMine.mineVein(blockName)
    print("called recursive vein mine function")
    -- mine/check above
    local has_block, details = turtle.inspectUp()
    if has_block then
        if details["name"] == blockName then
            smac.goUp()
            smartMine.mineVein(blockName)
            smac.goDown()
        end
    end

    -- mine/check below
    has_block, details = turtle.inspectDown()
    if has_block then
        if details["name"] == blockName then
            smac.goDown()
            smartMine.mineVein(blockName)
            smac.goUp()
        end
    end

    -- mine/check in front
    has_block, details = turtle.inspect()
    if has_block then
        if details["name"] == blockName then
            smac.goForward()
            smartMine.mineVein(blockName)
            smac.goBackward()
        end
    end

    -- mine/check to the left
    turtle.turnLeft()
    has_block, details = turtle.inspect()
    if has_block then
        if details["name"] == blockName then
            smac.goForward()
            smartMine.mineVein(blockName)
            smac.goBackward()
        end
    end
    turtle.turnRight()

    -- mine/check to the right
    turtle.turnRight()
    has_block, details = turtle.inspect()
    if has_block then
        if details["name"] == blockName then
            smac.goForward()
            smartMine.mineVein(blockName)
            smac.goBackward()
        end
    end
    turtle.turnLeft()

    -- mine/check behind
    smac.turn180()
    has_block, details = turtle.inspect()
    local behind_moved = false
    if has_block then
        if details["name"] == blockName then
            behind_moved = true
            smac.goForward()
            smartMine.mineVein(blockName)
        end
    end
    -- reorient regardless, and move back into slot if we had moved forward
    smac.turn180()
    if behind_moved == true then 
        smac.goForward() 
    end

    return true
end

--[[
    Recursively gathers a pool of lava. Checks each direction for lava, and if it's there, it will refuel from its current lava bucket, and then gather that lava
    and move into its spot. Then it recursively calls again.

    Assumes that we are already selecting a bucket!! If we swap our selected item at any point in this process it will break. Making it check in the function
    would be bad, because our item selecting iterates through the whole inventory, which is really slow if we do it at every recursive step

    The logic should work regardless of if we have an empty bucket or lava bucket. We always refuel right before gathering a new lava block, so when we recurse
    we should always end with a filled lava bucket in our inventory to give to our child.
]]
function smartMine.gatherLava(depth, maxDepth)
    print(("called recursive lava gather function with depth %d").format(depth))
    
    -- If we've reached mass recursion depth, just return
    if depth > maxDepth then
        return false
    end

    -- check above
    local has_block, details = turtle.inspectUp()
    if has_block then
        if details["name"] == "minecraft:lava" then
            turtle.refuel()
            turtle.placeUp()
            smac.goUp()
            smartMine.gatherLava(depth+1, maxDepth)
            smac.goDown()
        end
    end

    -- check below
    has_block, details = turtle.inspectDown()
    if has_block then
        if details["name"] == "minecraft:lava" then
            turtle.refuel()
            turtle.placeDown()
            smac.goDown()
            smartMine.gatherLava(depth+1, maxDepth)
            smac.goUp()
        end
    end

    -- check in front
    has_block, details = turtle.inspect()
    if has_block then
        if details["name"] == "minecraft:lava" then
            turtle.refuel()
            turtle.place()
            smac.goForward()
            smartMine.gatherLava(depth+1, maxDepth)
            smac.goBackward()
        end
    end

    -- check to the left
    turtle.turnLeft()
    has_block, details = turtle.inspect()
    if has_block then
        if details["name"] == "minecraft:lava" then
            turtle.refuel()
            turtle.place()
            smac.goForward()
            smartMine.gatherLava(depth+1, maxDepth)
            smac.goBackward()
        end
    end
    turtle.turnRight()

    -- check to the right
    turtle.turnRight()
    has_block, details = turtle.inspect()
    if has_block then
        if details["name"] == "minecraft:lava" then
            turtle.refuel()
            turtle.place()
            smac.goForward()
            smartMine.gatherLava(depth+1, maxDepth)
            smac.goBackward()
        end
    end
    turtle.turnLeft()

    -- check behind
    smac.turn180()
    has_block, details = turtle.inspect()
    local behind_moved = false
    if has_block then
        if details["name"] == "minecraft:lava" then
            behind_moved = true
            turtle.refuel()
            turtle.place()
            smac.goForward()
            smartMine.gatherLava(depth+1, maxDepth)
        end
    end
    -- reorient regardless, and move back into slot if we had moved forward
    smac.turn180()
    if behind_moved == true then 
        smac.goForward() 
    end

    return true
end

------ RETURN LIBRARY -------
return smartMine
-----------------------------