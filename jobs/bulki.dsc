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
                - cooldown 3s
                - narrate "<server.flag[pfx_bulki]><&f> Greetings! I'm Bulki, of The Scrapclad Collective! Let me know if you're interested in learning more about us."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_bulki]><&f> If you'd like to join The Scrapclad Collective as a Scrapper, you'll need to <&hover[<&a>[Obtain an Iron Nugget]]><&6>bring me an iron nugget<&end_hover><&f>..."
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - cooldown 3s
                - if <player.inventory.contains_item[iron_nugget]>:
                    - narrate "<server.flag[pfx_bulki]><&f> That Iron Nugget looks nice! You've completed my quest. Impressive work!"
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_bulki]><&f> Where's your shiny nugget? As a reminder, you need to <&hover[<&a>[Obtain an Iron Nugget]]><&6>bring me an iron nugget<&end_hover><&f>!"

        # main - job handout script
        4:
            click trigger:
                script:
                - cooldown 3s
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Scrapper].contains_text[True]>:
                    - narrate "<server.flag[pfx_bulki]><&f> Hiya fellow Scrapper. We can scrap all kinds of tools and gear for materials!"
                - else:
                    - narrate "<server.flag[pfx_bulki]><&f> Wanna join The Scrapclad Collective and become a Scrapper? <server.flag[npc_dialouge_yes]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[pfx_bulki]><&f> You have too many jobs! Leave one to become a Scrapper <server.flag[npc_dialouge_leavejob]>"
                    - else:
                        - jobs join Scrapper
                        - narrate "<&9>You have been employed as a Scrapper. Welcome to The Scrapclad Collective!"
                        - wait 2s
                        - narrate "<server.flag[pfx_bulki]><&f> Get those hands dirty! Let's see what resources you can bring new life."