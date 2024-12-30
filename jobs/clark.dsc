#Clark is the NPC which hands out the Explorer job, located on the explorer island.
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
    steps:
        # npc intro
        1:
            click trigger:
                script:
                - narrate "<server.flag[pfx_clark]><&f> Hello, I'm Clark, the head of the Explorer's guild. Welcome, <player.name>! Come talk to me if you'd like to know more about the Explorer Guild."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - narrate "<server.flag[pfx_clark]><&f> If you'd like to join the Guild and become an Explorer, you'll need to <&hover[<&6>Brush a Suspicious block to obtain a Pottery Shard]><&6>respect the remnants<&end_hover><&f>..."
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - ratelimit <player> 5s
                - if <player.has_advancement[minecraft:adventure/salvage_sherd]>:
                    - narrate "<server.flag[pfx_clark]><&f> Well done! You've completed my quest. Impressive work!"
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_clark]><&f> It seems you haven't finished the quest yet. As a reminder, you need to <&hover[<&6>Brush a Suspicious block to obtain a Pottery Shard]><&6>respect the remnants<&end_hover><&f>!"

        # main - job handout script
        4:
            click trigger:
                script:
                - ratelimit <player> 5s
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Explorer].contains_text[True]>:
                    - narrate "<server.flag[pfx_clark]><&f> Hello Explorer! Perhaps one day all of the lands will be explored."
                - else:
                    - narrate "<server.flag[pfx_clark]><&f> Would you like to join the ranks of the Explorers? <&hover[<&6>Become an Explorer]><&8><element[[Yes]].on_click[/denizenclickable chat Yes]><&end_hover>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[pfx_clark]><&f> You have too many jobs! Leave one to become an Explorer <&hover[<&8>/jobs leave]><&8><element[/jobs leave].on_click[/jobs leave ].type[SUGGEST_COMMAND]><&end_hover>"
                    - else:
                        - jobs join Explorer
                        - narrate "<&6>You have been employed as an Explorer"
                        - wait 2s
                        - narrate "<server.flag[pfx_clark]><&f> Welcome aboard! Hot air balloon not included, haha."