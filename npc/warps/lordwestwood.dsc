lordwestwood:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - lordwestwood_main

lordwestwood_main:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                - cooldown 5s
                - narrate "<server.flag[pfx_lordwestwood]><&f> Esteemed patron, you may address me as Lord Westwood."
                - wait 2s
                - narrate "<server.flag[pfx_lordwestwood]><&f> Pray tell — upon which floor shall I escort you?"
                - zap 2
        2:
            click trigger:
                script:
                - execute as_server "dm open adminshop_menu <player.name>"