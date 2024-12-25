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
                - ratelimit <player> 120s
                - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Rune<&f>: Two brown mushrooms and a touch of glowstone..."
                - wait 5s
                - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Rune<&f>: Hello <player.name> I'm busy at the moment, but visit me later if you're interested in joining the Sorcerer's guild."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Rune<&f>: Do you have an affinity for alchemy? You may join the Sorcerer's guild once you've <&hover[<&6>Brew a Potion]><&6>brewed a potion<&end_hover><&f>."
                - zap 3

        # give quest
        3:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:nether/brew_potion]>:
                    - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Rune<&f>: Ah! So you've brewed a potion... Perhaps you would do..."
                    - zap 4
                - else:
                    - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Rune<&f>: Come back once you've <&hover[<&6>Brew a Potion]><&6>brewed a potion<&end_hover><&f>..."

        # main - job handout script
        4:
            click trigger:
                script:
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Sorcerer].contains_text[True]>:
                    - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Rune<&f>: Hello fellow Sorcerer. We should discuss potion brewing sometime."
                - else:
                    - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Rune<&f>: Would you like to join the guild and work as a Sorcerer? <&hover[<&6>Become a Sorcerer]><&8><element[[Yes]].on_click[/denizenclickable chat Yes]><&end_hover>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Rune<&f>: You must leave a job before you can become a Sorcerer <&hover[<&8>/jobs leave]><&8><element[/jobs leave].on_click[/jobs leave ].type[SUGGEST_COMMAND]><&end_hover>"
                    - else:
                        - jobs join Sorcerer
                        - narrate "<&6>You have been employed as a Sorcerer."
                        - wait 2s
                        - narrate "<&8>{<&f>Aeronaut<&8>} <&6>Rune<&f>: Do you feel the magic?"