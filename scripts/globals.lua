-- DEFINE MODULE --
local globals = {}
-------------------

--[[ ===================
This module contains lists and value that other modules in the library may need.
Check if an item is in a list by checking whether globals.NAME[thingToCheck] ~= nil.
Most are sets, where the key and value in the table are the same thing.
For some (like global.resourceCount), you can also get a count for the number by doing globals.NAME[thingToCheck]

we need to do the 'for' loops because the pure list versions aren't indexable (we can't check whether something is in them)
    - I wish we could just say arr = {name = true, name2 = true} etc., but the keys in the definition are only implicitly 
        treated like strings, and they can't have colons in them! which sucks :(
-- =================== ]]

            -- ============
            -- VALUES
            -- ============
globals.minimumFuel = 1100
globals.maximumFuel = 20000

            -- ============
            -- WHITELIST AND HELPER LISTS
            -- ============

globals.whitelisted = {}
local whitelistedNames = {"minecraft:diamond", "minecraft:redstone", "minecraft:raw_iron", "minecraft:lapis_lazuli", 
                    "minecraft:sugar_cane", "minecraft:cobblestone", "minecraft:sand", "minecraft:dirt", 
                    "minecraft:birch_sapling", "minecraft:birch_log", "minecraft:chest", "minecraft:bucket", "minecraft:lava_bucket"}
for index,name in ipairs(whitelistedNames) do
    globals.whitelisted[name] = name
end

globals.ores = {}
local oreNames = {"minecraft:diamond_ore", "minecraft:deepslate_diamond_ore", "minecraft:iron_ore", "minecraft:deepslate_iron_ore", 
                "minecraft:lapis_ore", "minecraft:deepslate_lapis_ore", "minecraft:redstone_ore", "minecraft:deepslate_redstone_ore"}
for index,name in ipairs(oreNames) do
    globals.ores[name] = name
end

            -- ============
            -- RESOURCES + RESOURCE COUNTS FOR MAIN RECIPE
            -- ============

globals.resources = {}
local resourceNames = {"minecraft:diamond", "minecraft:redstone", "minecraft:raw_iron", "minecraft:lapis_lazuli", 
                "minecraft:cobblestone", "minecraft:sand"}
for index,name in ipairs(resourceNames) do
    globals.resources[name] = name
end


globals.resourceCount = {}
    globals.resourceCount["minecraft:diamond"] = 3
    globals.resourceCount["minecraft:raw_iron"] = 10
    globals.resourceCount["minecraft:redstone"] = 4
    globals.resourceCount["minecraft:lapis_lazuli"] = 1
    globals.resourceCount["minecraft:cobblestone"] = 30
    globals.resourceCount["minecraft:sand"] = 6
    globals.resourceCount["minecraft:birch_log"] = 12
    globals.resourceCount["minecraft:birch_sapling"] = 4

            -- ============
            -- CRAFTING RECIPES
            -- ============

globals.craftingRecipes = {}
globals.craftingRecipes["minecraft:crafting_table"] = 
{"minecraft:birch_planks",      "minecraft:birch_planks",       "none", 
"minecraft:birch_planks",       "minecraft:birch_planks",       "none", 
"none",                         "none",                         "none"}

globals.craftingRecipes["minecraft:birch_planks"] = 
{"minecraft:birch_log",       "none",     "none", 
"none",                 "none",     "none", 
"none",                 "none",     "none"}

globals.craftingRecipes["minecraft:stick"] = 
{"minecraft:birch_planks",      "none",                     "none", 
"minecraft:birch_planks",       "none",                     "none", 
"none",                         "none",                     "none"}

globals.craftingRecipes["minecraft:diamond_pickaxe"] = 
{"minecraft:diamond",      "minecraft:diamond",        "minecraft:diamond", 
"none",                     "minecraft:stick",          "none", 
"none",                     "minecraft:stick",          "none"}

globals.craftingRecipes["minecraft:bucket"] = 
{"minecraft:iron_ingot",    "none",                     "minecraft:iron_ingot", 
"none",                     "minecraft:iron_ingot",     "none", 
"none",                     "none",                     "none"}

globals.craftingRecipes["minecraft:paper"] = 
{"minecraft:sugar_cane",        "minecraft:sugar_cane",         "minecraft:sugar_cane", 
"none",                         "none",                         "none", 
"none",                         "none",                         "none"}

globals.craftingRecipes["minecraft:blue_dye"] = 
{"minecraft:lapis_lazuli",      "none",          "none", 
"none",                         "none",          "none", 
"none",                         "none",          "none"}

globals.craftingRecipes["minecraft:chest"] =
{"minecraft:birch_planks",      "minecraft:birch_planks",        "minecraft:birch_planks", 
"minecraft:birch_planks",       "none",                          "minecraft:birch_planks", 
"minecraft:birch_planks",       "minecraft:birch_planks",        "minecraft:birch_planks"}

globals.craftingRecipes["minecraft:furnace"] =
{"minecraft:cobblestone",      "minecraft:cobblestone",        "minecraft:cobblestone", 
"minecraft:cobblestone",       "none",                         "minecraft:cobblestone", 
"minecraft:cobblestone",       "minecraft:cobblestone",        "minecraft:cobblestone"}

globals.craftingRecipes["minecraft:glass_pane"] =
{"minecraft:glass",      "minecraft:glass",         "minecraft:glass", 
"minecraft:glass",       "minecraft:glass",         "minecraft:glass", 
"none",                  "none",                    "none"}

globals.craftingRecipes["computercraft:computer"] =
{"minecraft:stone",      "minecraft:stone",         "minecraft:stone", 
"minecraft:stone",       "minecraft:redstone",      "minecraft:stone", 
"minecraft:stone",       "minecraft:glass_pane",    "minecraft:stone"}


globals.craftingRecipes["computercraft:disk_drive"] =
{"minecraft:stone",      "minecraft:stone",        "minecraft:stone", 
"minecraft:stone",       "minecraft:redstone",     "minecraft:stone", 
"minecraft:stone",       "minecraft:redstone",     "minecraft:stone"}

globals.craftingRecipes["computercraft:turtle"] =
{"minecraft:iron_ingot",      "minecraft:iron_ingot",           "minecraft:iron_ingot", 
"minecraft:iron_ingot",       "computercraft:computer_normal",  "minecraft:iron_ingot", 
"minecraft:iron_ingot",       "minecraft:chest",                "minecraft:iron_ingot"}

globals.craftingRecipes["computercraft:disk"] =
{"minecraft:redstone",      "minecraft:paper",          "none", 
"minecraft:blue_dye",       "none",                     "none", 
"none",                     "none",                     "none"}

-- technically the item created by these is still named 'computercraft:turtle_normal'
globals.craftingRecipes["computercraft:crafty_turtle"] =
{"computercraft:turtle_normal",      "minecraft:crafting_table",        "none", 
"none",                              "none",                            "none", 
"none",                              "none",                            "none"}

globals.craftingRecipes["computercraft:miney_crafty_turtle"] =
{"minecraft:diamond_pickaxe",      "computercraft:turtle_normal",       "none", 
"none",                            "none",                              "none", 
"none",                            "none",                              "none"}

-- RETURN MODULE --
return globals