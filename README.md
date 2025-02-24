# Scute Swarm
<a href="https://ibb.co/yWGdSrG"><img src="https://i.ibb.co/GcBnTqB/example-Logo.png" alt="logo" border="0" align="center" width="100"/></a>

Scute Swarm is a self-replication library for CC:Tweaked turtles rooted in MerlinLikeTheWizard's [strategy](https://www.youtube.com/watch?v=MXYZufNQtdQ). Turtles mine for resources, grow sugarcane and plant trees, and craft a copy of themselves which repeats the process. In order for this to work, the turtles must remain chunkloaded, and the config for the world must disable fuel usage for turtles.


## How to Use
Take a look at INSTALLATION.md for guidance on downloading and enabling ComputerCraft. Once you have ComputerCraft installed, create a world you'd like to use the program in, then follow the steps in How To Turn Off Fuel to disable fuel in the world.

Once that's done, re-enter the world and place down a Miney Crafting Turtle (a turtle equipped with a diamond pickaxe and a crafting table). Place 1 piece of Sugar Cane, 2 Birch Saplings, and one Crafting Table into its inventory. Then, you can run this command to download the installer for the program: 
    
    wget "https://raw.githubusercontent.com/ZermbaGerd/scute-swarm/refs/heads/main/scripts/installer.lua" installer

Then, run the installer program by just typing `installer` into the command line.

Once the installer has been run, you can run `main` to begin the program. It will repeat indefinitely.


### How To Turn Off Fuel
- Go to the folder for your ComputerCraft profile. This will be the directory you created by following INSTALLATION.md
    - Click the 'saves' folder, which contains info about particular worlds
    - Select the world you want to turn fuel off for, then go to the 'serverconfig' folder
        - Open the computercraft-server.toml file
        - Ctrl+F for fuel
            - There will be a line that says `need_fuel = true`. Change it to say false
        - Save the file, and you're done



## Notes

**ComputerCraft** is a mod for Minecraft which adds computers which are programmable with the Lua programming language. **ComputerCraft: Tweaked** is a fork of the mod for newer Minecraft versions.

This project lives [on GitHub](https://github.com/ZermbaGerd/scute-swarm) and might not render correctly on third-party websites.

A note on abbreviations: `CC` is ComputerCraft, `CC:T` is ComputerCraft: Tweaked, and `CC:R` is ComputerCraft: Restitched.

Structure of README borrowed from [this project](https://github.com/tomodachi94/awesome-computercraft)