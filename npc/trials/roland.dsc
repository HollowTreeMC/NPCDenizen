#this script is for roland at the pvp island
roland:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - roland_portal_main

roland_main:
    type: interact
    debug: false
    steps:
        # first time meeting the NPC
        1:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_roland]><&f> Here is the entrance to the Overworld trial chamber."

        # spend 5 sigils to attempt the overworld trial
        2:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_roland]><&f> It'll be 10 sigils to open the passage."


roland_dungeon_runtime:
    type: task
    debug: false
    definitions: loc_cornerstone:locationtag, player<player>
    script:
        ## SETUP
        # define spawner coordinates relative to cornerstone
        # first trial's location: <location[-800,65,-2400,Utility]>
        - define loc_cornerstone:<[loc_cornerstone]>
        - define loc_spawner_01:<[loc_cornerstone].add[-85,24,34]>
        - define loc_spawner_02:<[loc_cornerstone].add[-85,25,66]>
        - define loc_spawner_03:<[loc_cornerstone].add[-85,26,97]>
        - define loc_spawner_04:<[loc_cornerstone].add[-85,27,129]>
        - define loc_spawner_05:<[loc_cornerstone].add[-85,28,159]>

        # define spawner NBT with modifyblock
        #e.g. trial_spawner[block_entity_data={id:"minecraft:trial_spawner",required_player_range:14,target_cooldown_length:3600,normal_config:{spawn_range:4,total_mobs:20,simultaneous_mobs:10,ticks_between_spawn:1,spawn_potentials:[{data:{entity:{id:"minecraft:zombie"}},weight:3},{data:{entity:{id:"minecraft:husk"}},weight:1}]},spawn_potentials:[{data:{entity:{id:"minecraft:zombie"}},weight:3},{data:{entity:{id:"minecraft:husk"}},weight:1}]}]
        - modifyblock <[loc_spawner_01]> stone

        # this whole NBT thing is not really going anywhere. I think I might just use schematics to cheese it.

        # - adjustblock <[loc_spawner_01]> 

        ## RUNTIME
        - define while_loop True
        - while <[while_Loop]>:
            # check to see if the player dies
            #
            # count remaining spawners
            # check NBT of spawner #1
            - define spawner_01 <definition[loc_spawner_01].block>
            - define spawner_01_dat <definition[spawner_01].nbt_to_map>

        ## COMPLETE
        # reward the player based of the number of spawners cleared

        # teleport the player back to the pvp island

