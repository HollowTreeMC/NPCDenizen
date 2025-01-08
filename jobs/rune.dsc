#Rune is the NPC which hands out the Sorcerer job, located on the portal island inside the brewery hall.
rune:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
    interact scripts:
    - rune_main

rune_main:
    type: interact
    steps:
        # npc intro
        1:
            click trigger:
                script:
                - cooldown 120s
                - narrate "<server.flag[pfx_rune]><&f> Two brown mushrooms and a touch of glowstone..."
                - wait 5s
                - narrate "<server.flag[pfx_rune]><&f> <player.name>, I'm busy at the moment... but visit me later if you're interested in joining The Order of Runes."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_rune]><&f> Do you have an affinity for alchemy? You may join The Order of Runes once you've <&hover[<&a>[Brew a Potion]]><&6>brewed a potion<&end_hover><&f>."
                - zap 3

        # give quest
        3:
            click trigger:
                script:
                - cooldown 3s
                - if <player.has_advancement[minecraft:nether/brew_potion]>:
                    - narrate "<server.flag[pfx_rune]><&f> Ah! So you've brewed a potion... Perhaps you would do..."
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_rune]><&f> Come back once you've <&hover[<&a>[Brew a Potion]]><&6>brewed a potion<&end_hover><&f>..."

        # main - job handout script
        4:
            click trigger:
                script:
                - cooldown 3s
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Sorcerer].contains_text[True]>:
                    - narrate "<server.flag[pfx_rune]><&f> Fellow Runeweaver. We should discuss potion brewing sometime."
                - else:
                    - narrate "<server.flag[pfx_rune]><&f> Would you like to join The Order of Runes, as a Runeweaver? <server.flag[npc_dialouge_yes]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[pfx_rune]><&f> You must leave a job before you can become a Runeweaver <server.flag[npc_dialouge_leavejob]>"
                    - else:
                        - jobs join Sorcerer
                        - narrate "<&9>You have been employed as a Runeweaver."
                        - wait 2s
                        - narrate "<server.flag[pfx_rune]><&f> Do you feel the arcane?"