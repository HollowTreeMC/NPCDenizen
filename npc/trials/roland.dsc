#this script is for roland at the pvp island, who gates the entry to the mob spawner
roland:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - roland_main

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
                - zap 2

        # spend 5 sigils to attempt the overworld trial
        2:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_roland]><&f> It'll be 10 sigils to open the passage."
                # implement purchase element here
                # first trial's location:
                - ~run roland_dungeon_runtime def:<location[-800,65,-2400,Utility]>|<player>

roland_dungeon_runtime:
    type: task
    debug: false
    definitions: loc_main|player
    script:
        - define loc_main:<[loc_main]>
        - define <player>:<[player]>

        ## SETUP
        # define spawn coordinates
        - define loc_start:<[loc_main].add[-84.5,25,3.5]>
        # define spawner coordinates
        - define loc_1:<[loc_main].add[-85,24,33]>
        - define loc_2:<[loc_main].add[-85,25,65]>
        - define loc_3:<[loc_main].add[-85,26,96]>
        - define loc_4:<[loc_main].add[-85,27,128]>
        - define loc_5:<[loc_main].add[-85,27,158]>

        # define play cuboid coordinates
        - define play_left_bot:<[loc_main].add[-1,11,1]>
        - define play_right_top:<[loc_main].add[-169,72,228]>
        - define play_field:<cuboid[Utility,<[play_left_bot].x>,<[play_left_bot].y>,<[play_left_bot].z>,<[play_right_top].x>,<[play_right_top].y>,<[play_right_top].z>]>

        # define acid cuboid coordinates
        - define acid_left_bot:<[loc_main].add[-1,12,1]>
        - define acid_right_top:<[loc_main].add[-169,13,228]>
        - define play_field:<cuboid[Utility,<[acid_left_bot].x>,<[acid_left_bot].y>,<[acid_left_bot].z>,<[acid_right_top].x>,<[acid_right_top].y>,<[acid_right_top].z>]>

        # define spawner NBTs - vscode denizen is angyy but we don't care - paste these in from the google sheet
        - define nbt_1:trial_spawner{id:"minecraft:trial_spawner",required_player_range:7,target_cooldown_length:36000,normal_config:{spawn_range:4,total_mobs:20,simultaneous_mobs:10,ticks_between_spawn:1,spawn_potentials:[{data:{entity:{id:"minecraft:zombie"}},weight:3},{data:{entity:{id:"minecraft:husk"}},weight:1}]}}
        - define nbt_2:trial_spawner{id:"minecraft:trial_spawner",required_player_range:16,target_cooldown_length:120000,normal_config:{spawn_range:4,total_mobs:20,simultaneous_mobs:8,ticks_between_spawn:1,spawn_potentials:[{data:{entity:{id:"minecraft:zombie"}},weight:2},{data:{entity:{id:"minecraft:husk"}},weight:1},{data:{entity:{id:"minecraft:spider"}},weight:1}]}}
        - define nbt_3:trial_spawner{id:"minecraft:trial_spawner",required_player_range:16,target_cooldown_length:120000,normal_config:{spawn_range:4,total_mobs:16,simultaneous_mobs:8,ticks_between_spawn:2,spawn_potentials:[{data:{entity:{id:"minecraft:spider"}},weight:3},{data:{entity:{id:"minecraft:cave_spider"}},weight:1}]}}
        - define nbt_4:trial_spawner{id:"minecraft:trial_spawner",required_player_range:16,target_cooldown_length:120000,normal_config:{spawn_range:4,total_mobs:12,simultaneous_mobs:4,ticks_between_spawn:2,spawn_potentials:[{data:{entity:{id:"minecraft:cave_spider"}},weight:1},{data:{entity:{id:"minecraft:witch"}},weight:1}]}}
        - define nbt_5:trial_spawner{id:"minecraft:trial_spawner",required_player_range:4,target_cooldown_length:120000,normal_config:{spawn_range:4,total_mobs:15,simultaneous_mobs:3,ticks_between_spawn:20,spawn_potentials:[{data:{entity:{id:"minecraft:witch"}},weight:4},{data:{entity:{id:"minecraft:vindicator"}},weight:8},{data:{entity:{id:"minecraft:ravager"}},weight:1},{data:{entity:{id:"minecraft:creeper"}},weight:2}]}}

        # set spawners - vscode denizen is angerey, but still executes this command - first set the block to stone to avoid errors
        - foreach 1|2|3|4|5:
            - modifyblock <[loc_<[loop_index]>]> STONE
            - execute as_server 'minecraft:execute in minecraft:utility run minecraft:setblock <[loc_<[loop_index]>].x> <[loc_<[loop_index]>].y> <[loc_<[loop_index]>].z> minecraft:<[nbt_<[loop_index]>]>

        # begin trial
        - teleport <player> <[loc_start]>

#        ## RUNTIME
#        - define timer 500
#        - while <[timer]> > 0:
#            # check to see if the player dies
#
#            # count remaining spawners
#            - define spawner_states:<list[]>
#
#            - define spawner_1 <definition[loc_spawner_1].block>
#            - define spawner_1_dat <definition[spawner_1].nbt_to_map>
#
#            - ex <[timer]>--
#
#        ## COMPLETE
#        # entry conditions: death, spawners defeated, player leaves
#
#        # reward the player based of the number of spawners cleared
#
#        # teleport the player back to the pvp island

