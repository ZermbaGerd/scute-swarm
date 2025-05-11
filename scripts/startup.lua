--[[
        This is the code the turtle will run when it turns on. If it finds a disk drive near it, it copies code from the disk drive and runs
]]

print('This computer just started up')
if peripheral.find('drive') then
    print('found a disk drive near the turtle')
    shell.run("cp disk/calibration calibration")
    shell.run("cp disk/globals globals")
    shell.run("cp disk/smartActions smartActions")
    shell.run("cp disk/smartMine smartMine")
    shell.run("cp disk/smartCraft smartCraft")
    shell.run("cp disk/startup startup")
    shell.run("cp disk/main main")
    shell.run("cp disk/installer installer")
    print('this computer copied files from a floppy disk')
end

--[[
    Print messages for user to see if they forgot to give an item to the turtle
]]
local needItem = false
local smac = require("smartActions")
if smac.countItem("minecraft:chest") < 1 then
    print("Need a chest")
    needItem = true
end
if smac.countItem("minecraft:sugarcane") < 1 then
    print("Need a piece of sugarcane")
    needItem = true
end
if smac.countItem("minecraft:birch_sapling") < 2 then
    print("Need at least 2 birch saplings")
    needItem = true
end
if smac.countItem("minecraft:bucket") < 1 and smac.countItem("minecraft:lava_bucket") < 1 then
    print("Need a bucket or a lava bucket. If this is the first time starting, this needs a lava bucket")
    needItem = true
end

if needItem == true then
    os.sleep(5)
end

print("running the main function")
shell.run("main")