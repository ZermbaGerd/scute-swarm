---- DEFINE LIBRARY ----
local smartMine = {}
------------------------

local smac = require("smartActions")

--[[
    Digs in a straight line until it sees a block (in front, above, or below, but not left or right) 
    with either name1 or name2. These should be the regular ore and the deepslate version of the ore.

    Before every move, we check if we have enough fuel. If we don't, it immediately breaks and returns false
]]
local function digUntilFind(name1, name2)
    local foundOre = false
    local lookingForFuel = false
    if name1 == "minecraft:lava" or name1 == "minecraft:fuel" then
        lookingForFuel = true
    end

    while not foundOre do
        -- If we're not looking for fuel, and we don't have enough fuel, return false and break from the function
        if not lookingForFuel then
            if not smac.hasEnoughFuel then
                return false
            end
        end
        
        -- otherwise, check each block around us for the block and return true if we find it
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
        -- after checking each block, go forward
        smac.goForward()
    end
end

--[[
    Goes to the y-level for an ore, and then mines in a straight line until it finds that resource.
    Once it finds that resource, it dumps its excess items and mines the whole vein. At any point, if it
    goes below the fuel stockpile requirement, then it retuns false and exits the program.
]]
function smartMine.mineForBasicOre(ore)
    -- Y-levels to mine at are taken from https://minecraft.wiki/w/Ore#Distribution as of 11/4/24

    if ore == "diamond" or ore == "diamonds" then
        smac.goToY(-59)
        -- This digUntilFind check is what determines whether we have run out of fuel. If it returns false, we should break
        -- so we can go search for fuel in the 'main' loop
        local digResult = digUntilFind("minecraft:deepslate_diamond_ore", "minecraft:diamond_ore")
        if digResult == true then
        smac.smartDump()
        smartMine.mineVein("minecraft:deepslate_diamond_ore")
        smartMine.mineVein("minecraft:diamond_ore")
            return true
        else
            return false
        end

    elseif ore == "redstone" then
        smac.goToY(-59)
        local digResult = digUntilFind("minecraft:deepslate_redstone_ore", "minecraft:redstone_ore")
        if digResult == true then
        smac.smartDump()
        smartMine.mineVein("minecraft:deepslate_redstone_ore")
        smartMine.mineVein("minecraft:redstone_ore")
            return true
        else
            return false
        end

    elseif ore == "lapis" or ore == "lapis lazuli" then
        smac.goToY(-2)
        local digResult = digUntilFind("minecraft:deepslate_lapis_ore", "minecraft:lapis_ore")
        if digResult == true then 
        smac.smartDump()
        smartMine.mineVein("minecraft:deepslate_lapis_ore")
        smartMine.mineVein("minecraft:lapis_ore")
            return true
        else
            return false
        end


    elseif ore == "iron" then
        smac.goToY(14)
        local digResult = digUntilFind("minecraft:deepslate_iron_ore", "minecraft:iron_ore")
        if digResult == true then
        smac.smartDump()
        smartMine.mineVein("minecraft:deepslate_iron_ore")
        smartMine.mineVein("minecraft:iron_ore")
            return true
        else
            return false
        end
    
    -- this is a temp way to find sand w/o sticking to a surface
    -- based on the idea that we mostly want sand to grow sugarcane on, so it will be at water level
    -- 62 for the y should keep us at the top block of rivers / oceans, so we are walking through water
    elseif ore == "sand" then
        smac.goToY(62)
        local digResult = digUntilFind("minecraft:sand", "NONE")
        if digResult == true then 
        smac.smartDump()
        smac.minePrism(4,3,'top')
            return true
        else
            return false
        end
        
    elseif ore == "lava" or ore == "fuel" then
        smac.goToY(-55)
        digUntilFind("minecraft:lava", "NONE")
        -- select a lava bucket if we have one, if not select a bucket
        if smac.selectItem("minecraft:lava_bucket") == false then
            smac.selectItem("minecraft:bucket")
        end
        smartMine.gatherLava(0, 5)
    else
        print("invalid ore option")
        return false
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
    Helper function that checks the details of a block to see if it is a full block of lava. Just checking the name doesn't work, because sometimes
    it sees what should called "minecraft:flowing_lava" and still thinks it's lava. Just check the height of the lava to check.

    Accepts a "details" returned from a turtle.inspect() function. Returns true if it's a full lava block, false if it's not.
]]
local function checkLava(details)
    if details["name"] ~= "minecraft:lava" then
        return false
    elseif details["state"]["level"] ~= 0 then
        return false
    else
        return true
    end
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
        if checkLava(details) then
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
        if checkLava(details) then
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
        if checkLava(details) then
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
        if checkLava(details) then
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
        if checkLava(details) then
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
        if checkLava(details) then
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