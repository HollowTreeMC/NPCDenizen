## Discord Link NPC
discord_npc:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - discord_npc_main

discord_npc_main:
    type: interact
    debug: false
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 15s
                - playsound <player> sound:ui.button.click
                - narrate "<&nl><&8><&sp><&sp>[<&b>Discord<&8>]<&b>↗ <&hover[Click to Join our Discord]><element[<&color[#d3d3d3]><&n><&o>discord.gg/SCpm3Nfw3e].on_click[https://discord.gg/SCpm3Nfw3e].type[OPEN_URL]><&end_hover><&7> (click to open)<&nl>"

## Wiki Link NPC
wiki_npc:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - wiki_npc_main

wiki_npc_main:
    type: interact
    debug: false
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 15s
                - playsound <player> sound:ui.button.click
                - narrate "<&nl><&8><&sp><&sp>[<&a>HollowWiki<&8>]<&a>↗ <&hover[Click to View the Wiki]><element[<&color[#d3d3d3]><&n><&o>wiki.hollowcraft.net].on_click[https://wiki.hollowcraft.net].type[OPEN_URL]><&end_hover><&7> (click to open)<&nl>"

## Sigil Balance NPC
sigil_npc:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - sigil_npc_main

sigil_npc_main:
    type: interact
    debug: false
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - playsound <player> sound:ui.button.click
                - narrate "<&nl><&8>[<&e>Sigils<&8>]<&color[#d3d3d3]> <&hover[View on Wiki]><element[<&color[#d3d3d3]><&n>Sigils].on_click[https://wiki.hollowcraft.net/Sigils].type[OPEN_URL]><&end_hover>↗ <&r><&color[#d3d3d3]>are special tokens you can earn and spend all over HollowCraft! Use <&e>/sigil help<&color[#d3d3d3]> to learn more! <&nl>"
                - zap 2
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - playsound <player> sound:ui.button.click
                - execute as_player "sigil balance"

## Staff World Teleport NPC
staff_npc:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - staff_npc_main

staff_npc_main:
    type: interact
    debug: false
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if !<player.has_permission[denizen.admin]>:
                    - narrate hi

                - else:
                    - playsound <player> sound:entity.firework_rocket.launch
                    - random:
                        - narrate "hmm wait a minute... I don't work here!"
                        - narrate "Hey <player.name>! This area is staff-only!"
                        - narrate "Try somewhere else, secret meeting in progress.."
                        - narrate "What's the password? ... Just kidding, that's not how you gain access"