#Cogsworth is the NPC which hands out the Tinkerer job, located in the workshop.

## Flags used in this file:
# <server.flag[pfx_cogsworth]> is an elementTag - used as the prefix for this npc's messages
# <player.flag[npc_chatted]> is a boolean - used as a cooldown for entering a seperate zap state


cogsworth:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
    interact scripts:
    - cogsworth_main

cogsworth_main:
    type: interact
    debug: false
    steps:
        # npc introduction
        1:
            click trigger:
                script:
                - cooldown 120s
                - narrate "<server.flag[pfx_cogsworth]><&f> Where did I put my compass? Oh hello <player.name>. Want to join The Clockwork Assembly as a Tinkerer? Hmm...I'll come up with a test, come see me again later..."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - cooldown 5s
                - narrate "<server.flag[pfx_cogsworth]><&f> Suppose you could.. yes this will do!"
                - wait 2s
                - narrate "<server.flag[pfx_cogsworth]><&f> Make a <&hover[<&a>[Be near a Crafter when it crafts a Crafter]]><&6>crafter craft a crafter<&end_hover><&f>!"
                - zap 3

        # give quest
        3:
            click trigger:
                script:
                - cooldown 3s
                - if <player.has_advancement[minecraft:adventure/crafters_crafting_crafters]>:
                    - narrate "<server.flag[pfx_cogsworth]><&f> But of course! With a crafter! You're the one."
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_cogsworth]><&f> <player.name>, how would a <&hover[<&a>[Be near a Crafter when it crafts a Crafter]]><&6>crafter craft a crafter<&end_hover><&f>?"

        # job handout script
        4:
            click trigger:
                script:
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Tinkerer].contains_text[True]>:
                    - narrate "<server.flag[pfx_cogsworth]><&f> What did the differential gear tell the spigot? Hahahaha!"
                - else:
                    - narrate "<server.flag[pfx_cogsworth]><&f> Come, let me take you into my employ <server.flag[npc_dialogue_yesno]>"

                    # activate chat trigger, response if the player hasn't selected a response - this acts as a cooldown
                    - zap 5
                    - wait 15s
                    - zap 4
                    - if !<player.has_flag[npc_chatted]>:
                        - narrate "<server.flag[pfx_cogsworth]><&f> Aha there's my compass!"

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
                        - narrate "<server.flag[pfx_cogsworth]><&f> Dearie me, you're too involved to become a Tinkerer <server.flag[npc_dialogue_leavejob]>"
                    - else:
                        - jobs join Tinkerer
                        - narrate "<&9>You have been employed as a Tinkerer. Welcome to The Clockwork Assembly!"
                        - wait 2s
                        - narrate "<server.flag[pfx_cogsworth]><&f> I know you'll make wonderful contraptions!"
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s
                    - narrate "<server.flag[pfx_cogsworth]><&f> Ah, a shame but it's alright."
                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cogsworth]><&f> I didn't quite get that, could you repeat it?"