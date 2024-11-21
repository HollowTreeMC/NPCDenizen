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
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cali<&f>: Hi <player.name>! Welcome to Hollowtree! I'm Cali, your guide!"
                - wait 2s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cali<&f>: Here's your guide menu, you can access it anytime here!"
                - wait 2s
                - execute as_server "dm open guides_menu <player.name>"
                - zap 2
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cali<&f>: Hello <player.name>!"