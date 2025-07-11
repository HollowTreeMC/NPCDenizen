#Clark is the NPC which hands out the Trailblazer job, located on the explorer island.

## Flags used in this file:
# <server.flag[pfx_clark]> is an elementTag - used as the prefix for this npc's messages
# <player.flag[npc_chatted]> is a boolean - used as a cooldown for entering a seperate zap state


clark:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
    interact scripts:
    - clark_main

clark_main:
    type: interact
    debug: false
    steps:
        # npc intro
        1:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_clark]><&f> Hello, I'm Clark, the Captain of the Trailblazer Corps. Welcome, <player.name>! Come talk to me if you'd like to know more about us Trailblazers."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_clark]><&f> If you'd like to join the Trailblazer Corps and become a Trailblazer, you'll need to <&hover[<&a>[Brush a Suspicious block to obtain a Pottery Shard]]><&6>respect the remnants<&end_hover><&f>..."
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - cooldown 3s
                - if <player.has_advancement[minecraft:adventure/salvage_sherd]>:
                    - narrate "<server.flag[pfx_clark]><&f> Well done! You've completed my quest. Impressive work!"
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_clark]><&f> It seems you haven't finished the quest yet. As a reminder, you need to <&hover[<&a>[Brush a Suspicious block to obtain a Pottery Shard]]><&6>respect the remnants<&end_hover><&f>!"

        # main - job handout script
        4:
            click trigger:
                script:
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Trailblazer].contains_text[True]>:
                    - narrate "<server.flag[pfx_clark]><&f> Perhaps, one day, all of the lands will be explored, Trailblazer."
                - else:
                    - narrate "<server.flag[pfx_clark]><&f> Would you like to join the Trailblazer Corps? <server.flag[npc_dialogue_yesno]>"

                    # activate chat trigger, response if the player hasn't selected a response - this acts as a cooldown
                    - zap 5
                    - wait 15s
                    - zap 4
                    - if !<player.has_flag[npc_chatted]>:
                        - narrate "<server.flag[pfx_clark]><&f> The Collective is always recruiting."

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
                        - narrate "<server.flag[pfx_clark]><&f> You have too many jobs! Leave one to become a Trailblazer <server.flag[npc_dialogue_leavejob]>"
                    - else:
                        - jobs join Trailblazer
                        - narrate "<&9>You have been employed as a Trailblazer. Welcome to the Trailblazer Corps!"
                        - narrate "<server.flag[pfx_clark]><&f> Welcome aboard! Hot air balloon not included, haha."
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s
                    - narrate "<server.flag[pfx_clark]><&f> Alright, !"
                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_clark]><&f> What's that?"