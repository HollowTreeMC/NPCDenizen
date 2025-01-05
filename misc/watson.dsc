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
                    - narrate "<server.flag[pfx_fischer]><&f> It's a looong way down..."
                    - narrate "<server.flag[pfx_fischer]><&f> The whole world is down there..."

# I made some changes