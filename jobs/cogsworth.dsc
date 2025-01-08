#Cogsworth is the NPC which hands out the Tinkerer job, located in the workshop.
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
    steps:
        # npc introduction
        1:
            click trigger:
                script:
                - ratelimit <player> 120s
                - narrate "<server.flag[pfx_cogsworth]><&f> Where did I put my compass? Oh hello <player.name>. Want to join The Clockwork Assembly as a Tinkerer? Hmm...I'll come up with a test, come see me again later..."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - narrate "<server.flag[pfx_cogsworth]><&f> Suppose you could.. yes this will do!"
                - wait 2s
                - narrate "<server.flag[pfx_cogsworth]><&f> Make a <&hover[<&a>[Be near a Crafter when it crafts a Crafter]]><&6>crafter craft a crafter<&end_hover><&f>!"
                - zap 3

        # give quest
        3:
            click trigger:
                script:
                - ratelimit <player> 10s
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
                    - narrate "<server.flag[pfx_cogsworth]><&f> Come, let me take you into my employ \n<&8><&o>Respond with: <&hover[<&9>[Become a Tinkerer]]><&8><element[[Yes]].on_click[/denizenclickable chat Yes]><&end_hover>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[pfx_cogsworth]><&f> Dearie me, you're too involved to become a Tinkerer <&hover[<&8>[/jobs leave]]><&8><element[/jobs leave].on_click[/jobs leave ].type[SUGGEST_COMMAND]><&end_hover>"
                    - else:
                        - jobs join Tinkerer
                        - narrate "<&9>You have been employed as a Tinkerer. Welcome to The Clockwork Assembly!"
                        - wait 2s
                        - narrate "<server.flag[pfx_cogsworth]><&f> I know you'll make wonderful contraptions!"