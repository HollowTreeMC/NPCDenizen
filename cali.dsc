cali:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - cali_main

cali_main:
    type: interact
    steps:
        1:
            proximity trigger:
                entry:
                    script:
                    - ratelimit <player> 100s
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cali<&f>: Hi <player.name>! Welcome to Hollowtree! I'm Cali, your guide!"
                    - wait 2s
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cali<&f>: Right click to speak with any Aeronaut or NPC here!"
            click trigger:
                script:
                    - zap 2
                    - execute as_server "dm open guides_menu <player.name>"
        2:
            click trigger:
                script:
                - ratelimit <player> 5s
                - execute as_server "dm open guides_menu <player.name>"
