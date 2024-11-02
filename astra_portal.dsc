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
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: We got a big haul this time!"
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: <player.name>? I'll remember you for next time."
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: An explosion? Probably just the sorcerer's guild having some fun."