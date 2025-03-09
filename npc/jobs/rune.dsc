#Rune is the NPC which hands out the Runweaver job, located on the portal island inside the brewery hall.
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
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Runeweaver].contains_text[True]>:
                    - narrate "<server.flag[pfx_rune]><&f> Fellow Runeweaver. We should discuss potion brewing sometime."
                - else:
                    - narrate "<server.flag[pfx_rune]><&f> Would you like to join The Order of Runes, as a Runeweaver? <server.flag[npc_dialogue_yesno]>"

                    # activate chat trigger, response if the player hasn't selected a response - this acts as a cooldown
                    - zap 5
                    - wait 15s
                    - zap 4
                    - if !<player.has_flag[npc_chatted]>:
                        - narrate "<server.flag[pfx_rune]><&f> This complex weavve demands my attention."

        # main's chat trigger
        5:
            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s

                    # join the player to the job
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[pfx_rune]><&f> You must leave a job before you can become a Runeweaver <server.flag[npc_dialogue_leavejob]>"
                    - else:
                        - jobs join Runeweaver
                        - narrate "<&9>You have been employed as a Runeweaver."
                        - narrate "<server.flag[pfx_rune]><&f> Do you feel the arcane?"
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s
                    - narrate "<server.flag[pfx_rune]><&f> I'll be here if you change your mind!"
                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_rune]><&f> Hm? I didn't get that."