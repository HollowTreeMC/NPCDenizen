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
                - random:
                    - narrate "<&7>{<&f>Black Marketeer<&7>}<&6>Xur<&f>: It's a looong way down..."
                    - narrate "<&7>{<&f>Black Marketeer<&7>}<&6>Xur<&f>: The whole world is down there..."