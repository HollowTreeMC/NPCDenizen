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
                - ratelimit <player> 10s
                - narrate "<server.flag[ender]><&f> Dare to face combat trials <player.name>?"
                - wait 1s
                - narrate "<server.flag[ender]><&f> There is no fee, say the word and I'll take you. <&8><element[[Okay]].on_click[/denizenclickable chat Yes]>"

            chat trigger:
                1:
                    trigger: /*/
                    hide trigger message: true
                    script:
                    - narrate "<server.flag[ender]><&f> Never a dull day."
                    - execute as_server "/effect <player.name> Blindness 2 255"
                    - wait 1s
                    - execute as_server "/warp <player.name> PvPIsland"
                    - wait 2s
                    - random:
                        - narrate "<server.flag[ender]><&f> I wonder what the statue is made of..."
                        - narrate "<server.flag[ender]><&f> I took an arrow to the knee once..."
                        - narrate "<server.flag[ender]><&f> HAH! I'd go down in the arena, but you wouldn't want that..."
                        - narrate "<server.flag[ender]><&f> Those warriors look mean..."