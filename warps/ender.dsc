ender:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - ender_main

ender_main:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_ender]><&f> Dare to face combat trials <player.name>? There is no fee, say the word and I'll take you. <server.flag[npc_dialogue_okay]>"

            chat trigger:
                1:
                    trigger: /*/
                    hide trigger message: true
                    script:
                    - execute as_server "/effect <player.name> Blindness 2 255"
                    - wait 1s
                    - execute as_server "/warp <player.name> PvPIsland"
                    - wait 1s
                    - random:
                        - narrate "<server.flag[pfx_ender]><&f> I wonder what the statue is made of..."
                        - narrate "<server.flag[pfx_ender]><&f> I took an arrow to the knee once..."
                        - narrate "<server.flag[pfx_ender]><&f> HAH! I'd go down in the arena, but you wouldn't want that..."
                        - narrate "<server.flag[pfx_ender]><&f> Those warriors look mean..."