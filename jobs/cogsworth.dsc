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
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: Where did I put my compass? Oh hello <player.name>. Want to become a tinkerer? Hmm...I'll come up with a test, come see me again later..."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: Suppose you could.. yes this will do!"
                - wait 2s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: Make a <&hover[<&6>Be near a Crafter when it crafts a Crafter]><&6>crafter craft a crafter<&end_hover><&f>!"
                - zap 3

        # give quest
        3:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:adventure/crafters_crafting_crafters]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: But of course! With a crafter! You're the one."
                    - zap 4
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: <player.name>, how would a <&hover[<&6>Be near a Crafter when it crafts a Crafter]><&6>crafter craft a crafter<&end_hover><&f>?"

        # job handout script
        4:
            click trigger:
                script:
                - if <placeholder[jobsr_user_isin_Tinkerer].contains_text[True]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: What did the differential gear tell the spigot? Hahahaha!"
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: Come, let me take you into my employ <&hover[<&6>Become a Tinkerer]><&7><element[[Yes]].on_click[/denizenclickable chat Yes]><&end_hover>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: Dearie me, you're too involved to become a Tinkerer <&hover[<&7>/jobs leave]><&7><element[/jobs leave].on_click[/jobs leave ].type[SUGGEST_COMMAND]><&end_hover>"
                    - else:
                        - jobs join Tinkerer
                        - narrate "<&6>You have been employed as a Tinkerer"
                        - wait 2s
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: I know you'll make wonderful contraptions!"