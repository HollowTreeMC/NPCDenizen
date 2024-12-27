#this script is for the fisherman at spawn
fischer:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - fischer_main

fischer_main:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - cooldown 10s
                - random:
                    - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Fischer<&f>: It's a looong way down..."
                    - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Fischer<&f>: The whole world is down there..."