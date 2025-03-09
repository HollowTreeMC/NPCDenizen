#Elara is the NPC which hands out the Bladewarden job, located on the PVP Island.
elara:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
    interact scripts:
    - elara_main

elara_main:
    type: interact
    steps:
        # npc intro
        1:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_elara]><&f> I'm the strongest Bladewarden here, making me the Commander of the Bladewarden Guard. Stop by if you want in."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_elara]><&f> Want to become a Bladewarden? Prove yourself by giving a pillager a <&hover[<&a>[Kill a pillager with a crossbow]]><&6>taste of their own medicine<&end_hover><&f>."
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - cooldown 3s
                - if <player.has_advancement[minecraft:adventure/whos_the_pillager_now]>:
                    - narrate "<server.flag[pfx_elara]><&f> Well done <player.name>! I knew you had the chops."
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_elara]><&f> Best a pillager by <&hover[<&a>[Kill a pillager with a crossbow]]><&6>becoming one<&end_hover><&f>..."

        # main - job handout script
        4:
            click trigger:
                script:
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Bladewarden].contains_text[True]>:
                    - narrate "<server.flag[pfx_elara]><&f> Bested anyone in combat recently?"
                - else:
                    - narrate "<server.flag[pfx_elara]><&f> Wanna join the Bladewarden Guard? <server.flag[npc_dialogue_yesno]>"

                    # activate chat trigger, response if the player hasn't selected a response - this acts as a cooldown
                    - zap 5
                    - wait 15s
                    - zap 4
                    - if !<player.has_flag[npc_chatted]>:
                        - narrate "<server.flag[pfx_elara]><&f> Hmm I wonder the weakspot of the Ender Dragon..."

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
                        - narrate "<server.flag[pfx_elara]><&f> You must leave a job before you can become a Bladewarden <server.flag[npc_dialogue_leavejob]>"
                    - else:
                        - jobs join Bladewarden
                        - narrate "<&9>You have been employed as a Bladewarden. Welcome to the Bladewarden Guard!"
                        - narrate "<server.flag[pfx_elara]><&f> Auriel's blessings be with you, Bladewarden."
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s
                    - narrate "<server.flag[pfx_elara]><&f> Auriel's blessings be with you nonetheless."
                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_elara]><&f> It's a simple question."