-- DEFINE LIBRARY----
local smartCraft = {}
---------------------

local smartActions = require("smartActions")
local smartMine = require("smartMine")
local globals = require("globals")

-----------------------
-- CHEST HELPERS
-- stole these from a forum post by fatboychummy: 
-- https://github.com/cc-tweaked/CC-Tweaked/discussions/1552#discussioncomment-6664168
-----------------------

--- Find an item in a chest, given the chest's position and item name.
---@param item_list itemList The list of items in the chest.
---@param item_name string The name of the item to find.
---@return integer? The slot number of the item, or nil if not found.
local function find_item(item_list, item_name)
    for slot, item in pairs(item_list) do
      if item.name == item_name then
        return slot
      end
    end
    return nil
end
  
--- Find the first empty slot in a chest.
---@param item_list itemList The list of items in the chest.
---@param size integer The size of the chest.
---@return integer? slot The slot number of the first empty slot, or nil if none are empty.
local function find_empty_slot(item_list, size)
    for slot = 1, size do
        if not item_list[slot] then
        return slot
        end
    end
    return nil
end
  
--- Move an item from one slot to another in a given inventory.
---@param inventory_name string The name of the inventory to move items in.
---@param from_slot integer The slot to move from.
---@param to_slot integer The slot to move to.
local function move_item_stack(inventory_name, from_slot, to_slot)
    return peripheral.call(inventory_name, "pushItems", inventory_name, from_slot, nil, to_slot)
end
  
--- Move a specific item to slot one, moving other items out of the way if needed.
---@param chest_name string The name of the chest to search.
---@param item_name string The name of the item to find.
---@return boolean success Whether or not the item was successfully moved to slot one (or already existed there)
function smartCraft.move_item_to_slot_one(chest_name, item_name)
    local list = peripheral.call(chest_name, "list")
    local size = peripheral.call(chest_name, "size")
    local slot = find_item(list, item_name)

    -- If the item didn't exist, or is already in the first slot, we're done.
    if not slot then
        print("Item not found")
        return false
    end
    if slot == 1 then
        print("Item already in slot 1")
        return true
    end
    
    -- If an item is blocking the first slot (we already know it's not the one we want), we need to move it.
    if list[1] then
        print("Slot 1 is occupied, moving to first empty slot")
        local empty_slot = find_empty_slot(list, size)

        -- If there are no empty slots, we can't move the item.
        if not empty_slot then
        print("No empty slots")
        return false
        end

        -- Move the item to the first empty slot.
        if not move_item_stack(chest_name, 1, empty_slot) then
        print("Failed to move item to slot " .. empty_slot)
        return false
        end

        print("Moved item to slot " .. empty_slot)
    end

    -- Move the item to slot 1.
    if move_item_stack(chest_name, slot, 1) == 0 then
        print("Failed to move item to slot 1")
        return false
    end

    print("Moved item to slot 1")
    return true
end

-----------------------
-- CHEST INTERACTION --
-----------------------

function smartCraft.getItemFromChest(item_name, count) 
    -- Assumes the turtle is facing a chest
    -- gets <count> items of the type <item_name> from the chest
    -- fails if turtle's inventory is full, or if the chest doesn't have the item
    if item_name == "None" or item_name == "none" or item_name == nil then
        return true
    end
    if smartCraft.move_item_to_slot_one("front", item_name) then
        return turtle.suck(count)
    else
        return false, "the chest doesn't have that item"
    end
end

function smartCraft.dumpAllExcept(materials)
    -- Assumes the turtle is facing a chest
    -- Takes a list of items 'materials' and dumps all items besides those from the inventory into that chest
    -- Returns true if successful, false otherwise
    local has_block, details = turtle.inspect()
    if (not has_block) then
        return false
    end
    if (details["name"] ~= "minecraft:chest") then
        return false
    end

    local startSlot = turtle.getSelectedSlot()
    for i=1,16 do
        local item_details = turtle.getItemDetail(i)
        if item_details ~= nil then
            if materials[item_details["name"]] == nil then
                turtle.select(i)
                turtle.drop()
            end
        end
    end
    turtle.select(startSlot)

end

function smartCraft.dumpCurrentSlot()
    -- Assumes the turtle is facing a chest
    -- Dumps the item it is currently selecting into that chest

    local has_block, details = turtle.inspect()
    if (not has_block) then
        return false
    end
    if (details["name"] ~= "minecraft:chest") then
        return false
    end
    turtle.drop()
    return true
end

function smartCraft.dumpAllItems()
    -- Assumes the turtle is facing a chest
    -- Dumps all of its items into that chest
    local has_block, details = turtle.inspect()
    if (not has_block) then
        return false
    end
    if (details["name"] ~= "minecraft:chest") then
        return false
    end
    local startSlot = turtle.getSelectedSlot()
    for i=1,16 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(startSlot)
    return true
end

function smartCraft.getAllItemsFromChest()
    -- Assumes the turtle is facing a chest
    -- Collects every item from that chest

    local has_block, details = turtle.inspect()
    if (not has_block) then
        return false
    end
    if (details["name"] ~= "minecraft:chest") then
        return false
    end

    for i = 1,27 do
        turtle.suck()
    end
end

-------------
-- FURNACE --
-------------

-- slot 1: thing to smelt, slot 2: fuel slot, slot 3: result
function smartCraft.addFuel(nLogs)
    -- Assumes the turtle is facing a furnace
    -- Adds nLogs logs to the furnace in front of it

    local has_block, details = turtle.inspect()
    if (not has_block) then
        return false
    end
    if (details["name"] ~= "minecraft:furnace") then
        return false
    end

end

function smartCraft.smeltCurrentItem(toSmelt)
    -- Assumes the turtle is facing a furnace with fuel in it
    -- Smelts toSmelt items in the current slot
    -- I think it should wait for those to smelt, and then be able to return stuff based on how successful it was?? idk

    local has_block, details = turtle.inspect()
    if (not has_block) then
        return false
    end
    if (details["name"] ~= "minecraft:furnace") then
        return false
    end

end
------------------------------------
-- Craft-Level Resource Gathering --
------------------------------------

-- Returns {success?, reason} :)
function smartCraft.growPlants()
    
    sugarCaneSuccess = smartCraft.growSugarCane(4)

    if (not sugarCaneSuccess) then
        return {false, "sugar cane growth failed"}
    end

    local treeLocationFound = smartCraft.createTreeLocation()
    if not treeLocationFound then
        return {false, "could not create location to grow tree"}
    end

    local logs = smartActions.countItem("minecraft:birch_log")
    local saps = smartActions.countItem("minecraft:birch_sapling")
    while ((logs < 13) or (saps < 4)) do
        smartActions.smartDump()
        local logSuccess, reason = smartCraft.growSapling()
        if (not logSuccess) then
            return {logSuccess, reason}
        end
        logs = smartActions.countItem("minecraft:birch_log")
        saps = smartActions.countItem("minecraft:birch_sapling")
    end

    smartActions.digDown() -- Break the dirt :)

    return {true, "plants grown successfully"} 
end

----------------
-- SUGAR CANE --
----------------

function smartCraft.growSugarCane(scToGrow)

    local foundSuitableLocation = smartCraft.findSugarCaneLocation()
    if not foundSuitableLocation then
        return false
    end

    -- Select the sugar cane, or return false if unsuccessful

    if smartActions.selectItem("minecraft:sugar_cane") == false then
        return false
    end

    local initialSugarCaneCount = turtle.getItemCount()

    local moved, r = smartActions.moveUp()
    if not moved then
        return false
    end

    local placed, re = turtle.placeDown()
    if not placed then
        return false
    end

    local moved2, rea = smartActions.moveUp()
    if not moved then
        return false
    end

    while (turtle.getItemCount() < ((initialSugarCaneCount-1) + scToGrow)) do
        local block_down, details = turtle.inspectDown()
        if block_down then
            if details["name"] == "minecraft:sugar_cane" then
                turtle.digDown() -- Not using smartActions here beacuse that gives us more info than we really need.
            end
        end
    end

    smartActions.moveDown()
    smartActions.digDown()
    for i=1,4 do
        turtle.turnLeft()
    end
    smartActions.moveDown()
    return true
end

-- Function that finds grass/dirt/sand that is next to water.
function smartCraft.findSugarCaneLocation()

    -- Find water
    smartCraft.locateWater()

    -- Now we're above water, but lets go up to make sure we're on top of the water!
    while true do
        local has_block, details = turtle.inspectDown()
        if has_block then
            if details["name"] ~= "minecraft:water" then
                break
            end
        end
        if not has_block then
            break
        end
        smartActions.goUp()
    end
    smartActions.goDown()

    -- Clear the area
    smartActions.goDown()
    smartActions.dig()
    smartActions.goUp()
    smartActions.dig()
    smartActions.goForward()
    smartActions.goUp()
    smartActions.goUp()
    smartActions.goUp()
    smartActions.goDown()
    smartActions.goDown()
    smartActions.goDown()
    
    -- We might want to check if we really have dirt-- but also dirt is so prevelant im not worried
    local haveDirt = smartActions.selectItem("minecraft:dirt")
    if (not haveDirt) then
        return false
    end
    turtle.placeDown()

    return true
end

-- Function that positions the turtle such that it is standing above water.
-- Does so by wandering around at water level.
function smartCraft.locateWater()
    -- Go to water level:
    smartActions.goToY(63)

    -- Go until we find water
    while true do
        local has_block, details = turtle.inspectDown()
        if has_block then
            if details["name"] == "minecraft:water" then
                break
            end
        end
        smartActions.goForward()
    end
end

----------------
-- GROW LOGS  --
----------------

-- Function goes to y=300, places dirt, yay!
-- returns a success boolean
function smartCraft.createTreeLocation()
    -- Go wayyy up in the sky
    smartActions.goToY(300)

    -- Select dirt
    if smartActions.selectItem("minecraft:dirt") == false then
        return false, "no dirt in inventory"
    end

    -- Place the dirt
    local placed, re = turtle.placeDown()
    if not placed then
        return false, re
    end

    return true
end


-- Function assumes that we're on a dirt block at y=300, grows the sapling that it has
-- Fails and returns false, reason if any step along the way fails
function smartCraft.growSapling()

    smartActions.goUp()

    -- Select sapling
    if smartActions.selectItem("minecraft:birch_sapling") == false then
        return false, "no sapling in inventory"
    end

    -- Place the sapling
    local place, rea = turtle.placeDown()
    if not place then
        return false, rea
    end

    smartActions.goBackward()
    smartActions.goDown()

    -- Wait for the tree to grow
    while true do
        local has_block, details = turtle.inspect()
        if has_block then
            if details["name"] == "minecraft:birch_log" then
                break
            end
        end
    end

    -- Mine the tree! :)
    smartCraft.chopTree()
    
    return {true, "suceeded in growing a tree!"}
end

function smartCraft.chopTree()
    -- Go up to the leaves
    while true do
        local has_block, details = turtle.inspectUp()
        if has_block then
            if details["name"] == "minecraft:birch_leaves" then
                break
            end
        end
        smartActions.goUp()
    end
    smartActions.goBackward()

    -- Mine the outer ring of leaves
    smartActions.goUp()
    smartActions.digUp()
    turtle.turnLeft()

    for i=1,2 do
        smartActions.goForward()
        smartActions.digUp()
    end
    turtle.turnRight()
    for i=1,3 do
        for i=1,4 do
            smartActions.goForward()
            smartActions.digUp()
        end
        turtle.turnRight()
    end
    smartActions.goForward()
    smartActions.digUp()
    turtle.turnRight()

    -- Mine the inner ring of leaves
    for i=1,2 do
        for i=1,3 do
            smartActions.goForward()
            smartActions.digUp()
        end
        turtle.turnLeft()
        for i=1,2 do
            for i=1,2 do
                smartActions.goForward()
                smartActions.digUp()
            end
            turtle.turnLeft()
        end
        for i=1,2 do
            smartActions.goForward()
            smartActions.digUp()
        end
        turtle.turnLeft()

        smartActions.goUp()
        smartActions.goUp()
        smartActions.goBackward()
    end

    smartActions.goForward()
    smartActions.goForward()
    smartActions.goDown()
    turtle.turnLeft()
    smartActions.goForward()
    
    -- Mine the logs
    while true do
        local hb, deetz = turtle.inspectDown()
        if hb then
            if deetz["name"] ~= "minecraft:birch_log" then
                break
            end
        end
        smartActions.goDown()
    end
end


-----------------------------
-- Literal Actual Crafting --
-----------------------------

--[[
    Craft the recipe in the given list. The list must be an array 9 long, with the first three indices being the top row, etc.
    Assumes the turtle is facing a chest which contains all the ingredients necessary to the recipe.
    Pass "None" or "none" for any slots without items in them.
    The crafted item(s) are placed into the chest, leaving the turtle's inventory empty after the operation.
]]
function smartCraft.craftRecipe(recipeList)
    smartCraft.dumpAllItems()

    for i=1,3 do
        turtle.select(i)
        smartCraft.getItemFromChest(recipeList[i], 1)
    end

    for i=4,6 do
        turtle.select(i+1)
        smartCraft.getItemFromChest(recipeList[i], 1)
    end

    for i=7,9 do
        turtle.select(i+2)
        smartCraft.getItemFromChest(recipeList[i], 1)
    end

    turtle.craft()
end


function smartCraft.craftTurtle()
    --[[
        Assuming it is facing a chest with all of the necessary materials (post-smelting), crafts a new miney-crafting turtle
    ]]

    -- craft all the planks we'll need for these (24 for everything, leaving 2 left over)
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])


    -- craft what we'll need to pass on our files
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:blue_dye"])
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:paper"])
    smartCraft.craftRecipe(globals.craftingRecipes["computercraft:disk"])
    smartCraft.craftRecipe(globals.craftingRecipes["computercraft:disk_drive"])

    -- craft what we'll need to equip our next turtle
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:stick"]) -- two planks
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:diamond_pickaxe"])
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:crafting_table"]) -- four planks
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:chest"]) -- eight planks for chest for new guy to hold
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:bucket"])
    
    
    -- craft all of our mechanical bits, ending with the fully equipped turtle
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:glass_pane"])
    smartCraft.craftRecipe(globals.craftingRecipes["computercraft:computer"])
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:chest"]) 
    smartCraft.craftRecipe(globals.craftingRecipes["computercraft:turtle"])
    smartCraft.craftRecipe(globals.craftingRecipes["computercraft:crafty_turtle"])
    smartCraft.craftRecipe(globals.craftingRecipes["computercraft:miney_crafty_turtle"])
end


--[[
    Craft the furnace and fuel for smelting. Assumes we are looking at a chest with sufficient resources.
]]
function smartCraft.prepSmelting()
    -- each plank smelts 1.5 items, so we need:
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])   -- 10 planks * 1.5 for 14 stone (2 planks leftover)
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])

    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])   -- 7 planks * 1.5 for 10 iron (1 plank left over)
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])

    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:birch_planks"])   -- 4 planks * 1.5 for 6 glass (no planks left-over)

    -- and we need the furnace
    smartCraft.craftRecipe(globals.craftingRecipes["minecraft:furnace"])
end


-- quick helper functions for working with smelt
local function goUnderFurnace()
    turtle.back()
    smartActions.goDown()
    smartActions.goDown()
    smartActions.goForward()
end

local function goAboveFurnace()
    turtle.back()
    smartActions.goUp()
    smartActions.goUp()
    smartActions.goForward()
end

--[[
    Assuming we're facing a chest with the sufficient resources, gets them, places the furnace
    and then smelts the desired resources
]]
function smartCraft.smelt()
    -- put a chest in front of us, and prep for furnace crafting
    smartActions.selectItem('minecraft:chest')
    turtle.place()
    smartCraft.dumpAllItems()

    -- get our furnace, fuel, and smelting materials
    smartCraft.getItemFromChest('minecraft:furnace', 1)

    smartCraft.getItemFromChest('minecraft:birch_planks',20)

    smartCraft.getItemFromChest('minecraft:cobblestone', 14)
    smartCraft.getItemFromChest('minecraft:sand', 6)
    smartCraft.getItemFromChest('minecraft:raw_iron', 10)

    -- place the furnace
    turtle.turnLeft()
    turtle.place()

    -- put the fuel in
    smartActions.goDown()
    smartActions.goForward()
    smartActions.selectItem('minecraft:birch_planks')
    turtle.dropUp()

    -- place cobble and wait for it to smelt
    goAboveFurnace()
    smartActions.selectItem('minecraft:cobblestone')
    turtle.dropDown()
    goUnderFurnace()

    while(smartActions.countItem('minecraft:stone') < 14) do
        turtle.suckUp()
        os.sleep(2)
    end

    -- place sand and wait for it to smelt
    goAboveFurnace()
    smartActions.selectItem('minecraft:sand')
    turtle.dropDown()
    goUnderFurnace()
    while(smartActions.countItem('minecraft:glass') < 6) do
        turtle.suckUp()
        os.sleep(2)
    end

    -- place iron and wait for it to smelt
    goAboveFurnace()
    smartActions.selectItem('minecraft:raw_iron')
    turtle.dropDown()
    goUnderFurnace()
    while(smartActions.countItem('minecraft:iron_ingot') < 10) do
        turtle.suckUp()
        os.sleep(2)
    end

    -- return to initial position
    turtle.back()
    smartActions.goUp()
    turtle.turnRight()
end

--[[
    Writes all of our programs to a floppy disk in a disk drive.
]]
local function writeToDiskDrive()
    shell.run("cp calibration disk/calibration")
    shell.run("cp globals disk/globals")
    shell.run("cp smartActions disk/smartActions")
    shell.run("cp smartMine disk/smartMine")
    shell.run("cp smartCraft disk/smartCraft")
    shell.run("cp startup disk/startup")
    shell.run("cp main disk/main")
    shell.run("cp installer disk/installer")
end

--[[
    Assumes we're facing a chest with a miney crafty turtle, disk drive, floppy disk, chest, sugar cane, and sapling.

    Places the new turtle and gives it the functions it needs to operate
]]
function smartCraft.placeTurtle()
    -- Get all of our stuff from the chest
    turtle.select(1)
    smartCraft.getItemFromChest('computercraft:turtle_normal', 1)
    smartCraft.getItemFromChest('computercraft:disk', 1)
    smartCraft.getItemFromChest('computercraft:disk_drive', 1)
    smartCraft.getItemFromChest('minecraft:sugar_cane', 1)
    smartCraft.getItemFromChest('minecraft:birch_sapling', 2)
    smartCraft.getItemFromChest('minecraft:chest', 1)
    smartCraft.getItemFromChest('minecraft:lava_bucket', 1)

    -- Place our disk drive
    turtle.turnRight()
    smartActions.selectItem('computercraft:disk_drive')
    turtle.place()

    -- Put the disk in it and write our programs to that disk
    smartActions.selectItem('computercraft:disk')
    turtle.drop()
    writeToDiskDrive()

    -- place our new turtle next to that disk drive
    turtle.turnRight()
    smartActions.goForward()
    smartActions.goForward()
    turtle.turnLeft()
    smartActions.goForward()
    turtle.turnLeft()
    smartActions.selectItem('computercraft:turtle_normal')
    turtle.place()

    -- give it the stuff it needs
    smartActions.selectItem('minecraft:sugar_cane')
    turtle.drop()
    smartActions.selectItem('minecraft:birch_sapling')
    turtle.drop()
    smartActions.selectItem("minecraft:chest")
    turtle.drop()
    smartActions.selectItem('minecraft:lava_bucket')
    turtle.drop()

    -- turn it on
    peripheral.call('front','turnOn')
end


--[[
    Pick up our chest and all the items in it, then dump anything that isn't used in the main non-crafting loop.
]]
function smartCraft.postPartum()
    turtle.turnLeft()
    smartActions.goForward()
    turtle.turnRight()
    smartActions.goForward()
    smartActions.goForward()
    smartCraft.getAllItemsFromChest()
    smartActions.goForward()
    smartActions.smartDump()
end


--[[
    Actually do all the crafting together.
]]
function smartCraft.completeCraftingProcess()
    -- place our chest and clear our inventory
    smartActions.selectItem('minecraft:chest')
    turtle.place()
    smartCraft.dumpAllItems()

    -- prep the materials we need to smelt
    smartCraft.prepSmelting()

    -- do the smelting
    smartCraft.smelt()

    -- craft the turtle
    smartCraft.craftTurtle()

    -- birth the new turtle
    smartCraft.placeTurtle()

    -- re-equip ourselves
    smartCraft.postPartum()
end

--- RETURN LIBRARY----
return smartCraft
----------------------