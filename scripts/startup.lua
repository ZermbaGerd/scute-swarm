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

print("running the main function")
shell.run("main")