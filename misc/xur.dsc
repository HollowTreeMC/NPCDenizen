#this script is for the black market dude at spawn
xur:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - Xur_main

xur_main:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - cooldown 10s
                - if <util.random_chance[1]>:
                    - narrate "<server.flag[pfx_xur]><&f> Wait, why am I blocky?"
                - else:
                    - random:
                        - narrate "<server.flag[pfx_xur]><&f> My function here is to trade. I know this."
                        - narrate "<server.flag[pfx_xur]><&f> I am filled with secrets, but you would not understand them."
                        - narrate "<server.flag[pfx_xur]><&f> May we speak?"
                        - narrate "<server.flag[pfx_xur]><&f> There is no reason to fear me."
                        - narrate "<server.flag[pfx_xur]><&f> Do not be alarmed, I have no reason to cause you harm."
