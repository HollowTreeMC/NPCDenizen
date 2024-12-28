#this script is for astra the astra clone at the portal island
astra_portal:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - astra_portal_main

astra_portal_main:
    type: interact
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 5s
                - random:
                    - narrate "<server.flag[astra]><&f> We got a big haul this time!"
                    - narrate "<server.flag[astra]><&f> <player.name>? I'll remember you for next time."
                    - narrate "<server.flag[astra]><&f> An explosion? Probably just the sorcerer's guild having some fun."