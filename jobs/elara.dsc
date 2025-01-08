#Elara is the NPC which hands out the Fighter job, located on the PVP Island.
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
                - cooldown 3s
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Fighter].contains_text[True]>:
                    - narrate "<server.flag[pfx_elara]><&f> Bested anyone in combat recently?"
                - else:
                    - narrate "<server.flag[pfx_elara]><&f> Wanna join the Bladewarden Guard? <server.flag[npc_dialouge_yes]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[pfx_elara]><&f> You must leave a job before you can become a Bladewarden <server.flag[npc_dialouge_leavejob]>"
                    - else:
                        - jobs join Fighter
                        - narrate "<&9>You have been employed as a Bladewarden. Welcome to the Bladewarden Guard!"
                        - wait 2s
                        - narrate "<server.flag[pfx_elara]><&f> Auriel's blessings be with you, Bladewarden."