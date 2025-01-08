#Sterling is the Smith job NPC
sterling:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
    interact scripts:
    - sterling_main

sterling_main:
    type: interact
    steps:
        # npc intro
        1:
            click trigger:
                script:
                - narrate "<server.flag[pfx_sterling]><&f> Hello, I'm Sterling, head of this here Gold Refinery. We can always use more hands at the forge, come talk to me if you want to be an Artificer."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<server.flag[pfx_sterling]><&f> Who's there? We need more hands at the forge, <&hover[<&a>[Craft an Iron Chestplate]]><&6>forge an iron chestplate<&end_hover><&f> to prove your mettle."
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:story/obtain_armor]>:
                    - narrate "<server.flag[pfx_sterling]><&f> Ah! A robust armour plate. Rough around the edges, but it'll do..."
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_sterling]><&f> Come back once you've <&hover[<&a>[Craft an Iron Chestplate]]><&6>forged a chestplate<&end_hover><&f>..."

        # main - job handout script
        4:
            click trigger:
                script:
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Smith].contains_text[True]>:
                    - narrate "<server.flag[pfx_sterling]><&f> You'll get arms of steel in no time!"
                - else:
                    - narrate "<server.flag[pfx_sterling]><&f> Would you like to join the Society of Innovation as an Artificer? \n<&8><&o>Respond with: <&hover[<&9>[Become a Smith]]><&8><element[[Yes]].on_click[/denizenclickable chat Yes]><&end_hover>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[pfx_sterling]><&f> You must leave a job before you can become a Artificer <&hover[<&8>[/jobs leave]]><&8><element[/jobs leave].on_click[/jobs leave ].type[SUGGEST_COMMAND]><&end_hover>"
                    - else:
                        - jobs join Smith
                        - narrate "<&9>You have been employed as a Artificer. Welcome to the Society of Innovation!"
                        - wait 2s
                        - narrate "<server.flag[pfx_sterling]><&f> Ha ha! Another to the Society of Innovation!"