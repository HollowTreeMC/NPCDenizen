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
                    - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Cali<&f>: Hi <player.name>! Welcome to Hollowtree! I'm Cali, your guide! Get started by <&e>right clicking <&f>NPCs such as myself!"
                    - wait 5s
                    - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Cali<&f>: I offer many guides, and if this is your first time here, I recommend viewing our <&e>Introduction to Hollowtree Guide! <&f>You'll be rewarded with coins for viewing any of these guides!"
                    - zap 2
            click trigger:
                script:
                    - execute as_server "dm open guides_menu <player.name>"
                    - zap 2

        2:
            click trigger:
                script:
                - execute as_server "dm open guides_menu <player.name>"

