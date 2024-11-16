lewis:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - lewis_main

lewis_main:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Lewis<&f>: Our guild has travelled far and wide, establishing many outposts!"
                - wait 2s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Lewis<&f>: Come talk to me if you want to visit one of them."
                - zap 2
        2:
            click trigger:
                script:
                - execute as_server "/dm open biomewarps_menu <player.name>"