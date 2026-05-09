#this script is for daily login rewards from Nara at spawn
nara:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - nara_main

nara_main:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                - ratelimit <player> 5s

                - if !<player.has_flag[nara_daily]>:
                    - narrate "<server.flag[pfx_nara]><&f> Here are your daily log in rewards!"
                    - execute as_server 'crates givekey votinator <player.name> 4'
                    - execute as_server 'sigil give <player.name> 6'
                    - flag <player> nara_daily:1 expire:22h

                - else:
                    - narrate "<server.flag[pfx_nara]><&f> Visit me tomorrow for more rewards!"
