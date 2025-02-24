# Step 1 - Get Minecraft
First, have Minecraft Java Edition installed on your system
- Should be somewhere around User/AppData/.minecraft
	- also accessible via %AppData$ then clicking .minecraft


# Step 2 - Get Fabric
Fabric is a mod loader, which helps Minecraft recognize mods, and gives modders particular tools to interact with Minecraft's environment. We'll be using Fabric for this project. I believe it's more lightweight than the main alternative, Forge.

You can download the Fabric installer [here](https://fabricmc.net/use/installer/)

Download and open that installer, and you should see a screen like this:![[Pasted image 20240915220642.png]]

When you're on this screen, make sure that the Launcher location matches the download location for Minecraft on your computer. 

If you want to follow this process  exactly, change the Minecraft Version to 1.20.1.

Once you've done that, click Install!

## Step 2.1 - Editing our Fabric Profile
Once you've run this installer, you can open your Minecraft Launcher. You can click whatever shortcut you may already have setup, or search for "Minecraft Launcher" in your system.

You may be prompted to log in with your Microsoft account. If so, just do so.

Once you're in, you should see a screen like this:
![Minecraft Launcher](minecraftLauncher.jpg)

Now, click the installations tab. You should get a screen listing a series of installations. On this list, you should see a profile called fabric-loader-1.20.1 - hooray!

We're now going to edit that profile, so that it doesn't share worlds, mods, and other resources with your other Minecraft profiles.

Start by hovering over the fabric profile, then clicking the three dots to the right of it. On that context menu, there should be a button to edit. Click that button, and a screen like this should pop up:
![[Pasted image 20240915221919.png]]
In the game directory slot, click browse, and then create a new folder somewhere you'll remember and not change. Select that folder for the game directory.

You can also change the name of this profile to something new, like "Computercraft".

Once you've made these changes, click Save.

Now, when you're on the main menu of the Minecraft Launcher, you should be able to click the drop-down menu that lists versions, and select your Computercraft profile. 

Now, launch Minecraft with the ComputerCraft profile once to prepare your directory for mods. You can close Minecraft right after getting to the main menu.

Now we're ready to actually install ComputerCraft and our other mods!

## Step 2.2 - Installing Fabric API\

For mods to use the tools that Fabric provides them, they need the Fabric API. Luckily for us, this is just a file we can download and include in our new profile!

Go to [this page](https://www.curseforge.com/minecraft/mc-mods/fabric-api/files/all) and look for the most recent Fabric API instance **FOR VERSION 1.20.1**. You can filter by game version in the top left corner of the search area, to make this easier.

Download that instance, and you should get a .jar file in your downloads folder.

Now that we have the .jar file in our Downloads folder, we're going to move it into our new ComputerCraft profile! Start by going to the directory you created in Step 2.1

In that folder, you should see some new things (If you've launched Minecraft using this profile):
![[Pasted image 20240915222734.png]]

If there is no folder named 'mods', create one. Then, put the .jar file in that folder.

Now you have the Fabric API in your project!
# Step 3 - Downloading ComputerCraft

Now, we can go to [this website](https://legacy.curseforge.com/minecraft/mc-mods/cc-tweaked/files/all) and download (the grey button, not the orange button) the most recent version of the mod. For the sake of this tutorial, we're using:
- cc-tweaked-**1.20.1-fabric**-1.113.1.jar
	- Note 1.20.1, fabric, and 1.113.1

You can download other versions of the mod, as long as they're still on 1.20.1 & fabric
- Note that there may be differences between your installation and ours if you do this.

When the download finishes (it should open a new page and count down from 5), you'll be given a .jar file. This is the file format of most Minecraft mods.

Move that jar file into the 'mods' folder you created in your ComputerCraft profile, and you're ready to use ComputerCraft!

# Step 4 - Optional But Helpful Add-Ons

## Step 4.1 - JEI (Just Enough Items)

JEI is a mod that makes navigating Minecraft recipes and item lists much easier. It's particularly useful when working with tons of mods, when it becomes infeasible to do all of your navigation solely through the Recipe Book.

To download JEI, just go to this page, and then download the most recent stable release for version 1.20.1. You can filter to game version 1.20.1, and then scroll until you see an option that has a green R next to it. At the time of writing this, ```
jei-1.20.1-fabric-15.12.2.51.jar``` is the most recent stable release.

That download will give you a jar file, and just like with fabric-api and Computercraft, you can put that jar file in your mods folder.

### Step 4.1.1 - Using JEI
Once you have JEI in your profile, opening your inventory will also open a long list of blocks/items on the side of your screen. Clicking on an item in this list will show how to craft that item, and right clicking will show recipes that use that item.

To search for all items that come from the same mod (like ComputerCraft!) you can use the @ symbol and then the mod name. For Computercraft, that would be @CC: Tweaked

IF you're using Creative Mode, you can hold Ctrl and click the wrench on the bottom right of the JEI inventory to turn on cheat mode. In cheat mode, when you click on an item in the list, it will give you one of them. Left click for a stack, right click for a single item.

### Some notes
We are using the CC: Tweaked mod, because the original ComputerCraft mod stopped being developed in like version 1.8.4 (a long time ago), so this is the currently supported fork of that mod.

We're going to use 1.20.1 because it's the most recent stable release of Minecraft & ComputerCraft at the time.