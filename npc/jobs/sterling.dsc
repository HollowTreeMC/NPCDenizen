#Sterling is the Artificer job NPC

## Flags used in this file:
# <server.flag[pfx_sterling]> is an elementTag - used as the prefix for this npc's messages
# <player.flag[npc_chatted]> is a boolean - used as a cooldown for entering a seperate zap state

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
    debug: false
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
                - cooldown 3s
                - narrate "<server.flag[pfx_sterling]><&f> Who's there? We need more hands at the forge, <&hover[<&a>[Craft an Iron Chestplate]]><&6>forge an iron chestplate<&end_hover><&f> to prove your mettle."
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - cooldown 7s
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
                - if <placeholder[jobsr_user_isin_Artificer].contains_text[True]>:
                    - narrate "<server.flag[pfx_sterling]><&f> You'll get arms of steel in no time!"
                - else:
                    - narrate "<server.flag[pfx_sterling]><&f> Would you like to join the Society of Innovation as an Artificer? <server.flag[npc_dialogue_yesno]>"

                    # activate chat trigger, response if the player hasn't selected a response - this acts as a cooldown
                    - zap 5
                    - wait 15s
                    - zap 4
                    - if !<player.has_flag[npc_chatted]>:
                        - narrate "<server.flag[pfx_sterling]><&f> Oh look! Astra has another shipment of Gold for me!"

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
                        - narrate "<server.flag[pfx_sterling]><&f> You must leave a job before you can become a Artificer <server.flag[npc_dialogue_leavejob]>"
                    - else:
                        - jobs join Artificer
                        - narrate "<&9>You have been employed as a Artificer. Welcome to the Society of Innovation!"
                        - narrate "<server.flag[pfx_sterling]><&f> Ha ha! Another to the Society of Innovation!"
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s
                    - narrate "<server.flag[pfx_sterling]><&f> A shame, your forging shows potential."
                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_sterling]><&f> Hmmm?"