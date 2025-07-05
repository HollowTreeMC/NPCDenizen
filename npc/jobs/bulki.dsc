#Bulki is the NPC who hands out the Tinkerer job, located on the spawn island.

## Flags used in this file:
# <server.flag[pfx_bulki]> is an elementTag - used as the prefix for this npc's messages
# <player.flag[npc_chatted]> is a boolean - used as a cooldown for entering a seperate zap state

# <player.flag[tutorial_bulki_quest]> is a boolean - used to coordinate with bulki NPC

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
    debug: false
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
                - narrate "<server.flag[pfx_bulki]><&f> If you'd like to join The Scrapclad Collective as a Scrapper, you'll need to <&hover[<&a>[Obtain an Copper Ingot]]><&6>bring me a copper ingot<&end_hover><&f>..."
                - wait 1s
                - if <player.has_flag[tutorial_bulki_quest]>:
                    - zap 9 cali_main
                    - wait 2s
                    - narrate "<server.flag[pfx_cali]><&f> <&l><player.name>! <&f>Sorry I forgot to give you the Copper Ingot! Catch!"
                    - give copper_ingot
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - cooldown 3s
                - if <player.inventory.contains_item[copper_ingot]>:
                    - narrate "<server.flag[pfx_bulki]><&f> That Copper Ingot looks nice! You've completed my quest. Impressive work!"
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_bulki]><&f> Where's your shiny nugget? As a reminder, you need to <&hover[<&a>[Obtain an opper Ingot]]><&6>bring me a copper ingot<&end_hover><&f>!"

        # main - job handout script
        4:
            click trigger:
                script:
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Scrapper].contains_text[True]>:
                    - narrate "<server.flag[pfx_bulki]><&f> Hiya fellow Scrapper. We can scrap all kinds of tools and gear for materials!"
                - else:
                    - narrate "<server.flag[pfx_bulki]><&f> Wanna join The Scrapclad Collective and become a Scrapper? <server.flag[npc_dialogue_yesno]>"

                    # activate chat trigger, response if the player hasn't selected a response - this acts as a cooldown
                    - zap 5
                    - wait 15s
                    - zap 4
                    - if !<player.has_flag[npc_chatted]>:
                        - narrate "<server.flag[pfx_bulki]><&f> The Collective is always recruiting."

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
                        - narrate "<server.flag[pfx_bulki]><&f> You have too many jobs! Leave one to become a Scrapper <server.flag[npc_dialogue_leavejob]>"
                    - else:
                        - jobs join Scrapper
                        - narrate "<&9>You have been employed as a Scrapper. Welcome to The Scrapclad Collective!"
                        - narrate "<server.flag[pfx_bulki]><&f> Get those hands dirty! Let's see what resources you can bring new life."
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s
                    - narrate "<server.flag[pfx_bulki]><&f> I'll be here if you change your mind!"
                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_bulki]><&f> What's that?"