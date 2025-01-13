# Okay so you want to be a computercraft coder. Let's hit a lil run-down


1. All our turtle's code is written in Lua - it's a functional programming language that does not support a lot of objects.
    - basically all data structures in lua are in the form of tables, which are sorta like dictionaries(or hashmaps)

2. turtles/computers have their own OS, which has plenty of basic commands you can run
    - But! most things we do with turtles we'll do through Lua, not through the OS. That means that if you want to play around with particular commands, you should open a Lua terminal first

3. turtles need fuel! (although we can change that in config depending on whether we want that to be something we're worried about for our project)
    - so as long as that's not changed in config, if your turtle is doing weird shit, you might want to refuel it

4. Turtles have fairly limited sensors/actuators, so the first big step for any project will probably be to give them some sort of persistent memory
    - for instance, at any given point in time, they basically only know what items are in their inventory, and the blocks to their front, top, and bottom
    - they also can only place objects in front of them


### How to send turtles scripts!
- You need to upload the text version of your script to pastebin (which allows you to just copy-paste text files/text onto their website)
    - then when it's uploaded, you'll get a page with a particular extension (like yGZjfU) or something.
    - go to your turtle/computer and run "pastebin get EXTENSION name_you_want_script_to_be" and it will do that
    - you can also do the opposite, where you upload to pastebin from the turtle, but that's scary and weird

- there might also be a way to do it from text files on your computer, or directly with a [VS Code extension](https://www.reddit.com/r/ComputerCraft/comments/o0648a/introducing_craftospc_remote_a_new_way_to_access/), but I haven't fucked with it too deeply
