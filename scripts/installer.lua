
--[[
    The installer module! Just run: 
        wget "https://raw.githubusercontent.com/ZermbaGerd/scute-swarm/refs/heads/main/scripts/installer.lua" installer
    to get this file
]]
function install()

    -- STARTUP (this runs when the computer turns on - gets data from a disk drive or just goes straight into main)
    shell.run("wget","https://raw.githubusercontent.com/ZermbaGerd/scute-swarm/refs/heads/fuel/scripts/startup.lua", "startup")

    -- MAIN (this is the main loop) (main)
    shell.run("wget","https://raw.githubusercontent.com/ZermbaGerd/scute-swarm/refs/heads/fuel/scripts/main.lua", "main")
    
    -- SMART ACTIONS (smac)
    shell.run("wget","https://raw.githubusercontent.com/ZermbaGerd/scute-swarm/refs/heads/fuel/scripts/smartActions.lua", "smartActions")

    -- CALIBRATION (calibration)
    shell.run("wget","https://raw.githubusercontent.com/ZermbaGerd/scute-swarm/refs/heads/fuel/scripts/calibration.lua", "calibration")

    -- GLOBALS (global)
    shell.run("wget","https://raw.githubusercontent.com/ZermbaGerd/scute-swarm/refs/heads/fuel/scripts/globals.lua", "globals")

    -- MINING STATE FUNCTIONS (smartMine)
    shell.run("wget","https://raw.githubusercontent.com/ZermbaGerd/scute-swarm/refs/heads/fuel/scripts/smartMine.lua", "smartMine")

    -- CRAFTING STATE FUNCTIONS (smartCraft)
    shell.run("wget","https://raw.githubusercontent.com/ZermbaGerd/scute-swarm/refs/heads/fuel/scripts/smartCraft.lua", "smartCraft")

end

install()

print("\n \n You now have all of your libraries installed! \n",
"The executable file for the actual program is 'main'. \n \n")