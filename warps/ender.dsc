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
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Ender<&f>: Dare to face combat trials <player.name>?"
                - wait 1s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Ender<&f>: There is no fee, say the word and I'll take you."

            chat trigger:
                1:
                    trigger: /*/
                    hide trigger message: true
                    script:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Ender<&f>: Never a dull day."
                    - execute as_server "/effect <player.name> Blindness 2 255"
                    - wait 1s
                    - execute as_server "/warp <player.name> PvPIsland"
                    - wait 2s
                    - random:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Ender<&f>: I wonder what the statue is made of..."
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Ender<&f>: I took an arrow to the knee once..."
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Ender<&f>: HAH! I'd go down in the arena, but you wouldn't want that..."
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Ender<&f>: Those warriors look mean..."