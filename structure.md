
# Mine State (get resources)
    - check resource completion
        - if complete, switch to craft state
    - otherwise pick next resource
    - go to that "state"


# Mine State
    - go to bedrock
    - while we still have resources to find:
        - go to the depth of the first resource (presumably diamonds)
        - while it still needs more of the resource it is on
            - mine around
            - periodically check if inventory is full
                - drop stuff if we don't need it
        - when it has enough of its current resource, see if it randomly picked up the next resource along the way; if so, check the resource after that, and so on until it finds one it needs or it's done
    - once it's done with all the mining, it has to get the sand, sugarcane, logs and planks, there's probably a similar but slightly different process to get those but idk exactly how they're found/grown
    - fuel would make this more complicated

# Craft State
    

            
