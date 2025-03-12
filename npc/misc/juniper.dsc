juniper:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - juniper_main

juniper_main:
    type: interact
    steps:
        1:
            click trigger:
                script:
                    - cooldown 3s
                    - narrate "<server.flag[pfx_juniper]><&f> The portal to the resource world is up and running. Status code Green. I've calibrated it to take you somewhere random. Fair winds!"