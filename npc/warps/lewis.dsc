lewis:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - lewis_main

lewis_main:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                - cooldown 5s
                - narrate "<server.flag[pfx_lewis]><&f> Our Guild has travelled far and wide, establishing many outposts!"
                - wait 2s
                - narrate "<server.flag[pfx_lewis]><&f> Come talk to me if you want to visit one of them."
                - zap 2
        2:
            click trigger:
                script:
                - execute as_server "dm open biomewarps_menu <player.name>"