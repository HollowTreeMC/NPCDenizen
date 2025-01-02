# Bulki is a job NPC who assigns the "Scrapper" job to players
bulki:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5

    interact scripts:
    - bulki_main

bulki_main:
    type: interact
    steps:
        # npc intro
        1:
            click trigger:
                script:
                - narrate "<server.flag[pfx_bulki]><&f> Hiya! I'm Bulki, Master Scrapper! Let me know if you're interested in learning more about our Scrapper Guild."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - narrate "<server.flag[pfx_bulki]><&f> If you'd like to join us as a Scrapper, you'll need to <&hover[<&a>[Obtain an Iron Nugget]]><&6>bring me an iron nugget<&end_hover><&f>..."
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - ratelimit <player> 5s
                - if <player.inventory.contains_item[iron_nugget]>:
                    - narrate "<server.flag[pfx_bulki]><&f> That Iron Nugget looks nice! You've completed my quest. Impressive work!"
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_bulki]><&f> Where's your shiny nugget? As a reminder, you need to <&hover[<&a>[Obtain an Iron Nugget]]><&6>bring me an iron nugget<&end_hover><&f>!"

        # main - job handout script
        4:
            click trigger:
                script:
                - ratelimit <player> 5s
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Scrapper].contains_text[True]>:
                    - narrate "<server.flag[pfx_bulki]><&f> Hiya fellow Scrapper. We can scrap all kinds of tools and gear for materials!"
                - else:
                    - narrate "<server.flag[pfx_bulki]><&f> Wanna finally become a Scrapper? <&hover[<&9>[Become a Scrapper]]><&8><element[[Yes]].on_click[/denizenclickable chat Yes]><&end_hover>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[pfx_bulki]><&f> You have too many jobs! Leave one to become a Scrapper <&hover[<&8>/jobs leave]><&8><element[/jobs leave].on_click[/jobs leave ].type[SUGGEST_COMMAND]><&end_hover>"
                    - else:
                        - jobs join Scrapper
                        - narrate "<&9>You're now a professional Scrapper!"
                        - wait 2s
                        - narrate "<server.flag[pfx_bulki]><&f> Get those hands dirty! Let's see what resources you can bring new life."