#Jett is the NPC which hands out the Quartermaster job, located inside the Tavern / Brewery.
jett:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
    interact scripts:
    - jett_main

jett_main:
    type: interact
    steps:
        # npc intro
        1:
            click trigger:
                script:
                - narrate "<server.flag[pfx_jett]><&f> Hey there, I'm Jett, master Brewer and Quartermaster."
                - wait 3
                - narrate "<server.flag[pfx_jett]><&f> Give me a holla if you'd like to join the Keepers of the Vault as a Quartermaster."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<server.flag[pfx_jett]><&f> A good Quartermaster needs to know how to <&hover[<&a>[Gently harvest honey with a campfire]]><&6>harvest honey safely<&end_hover><&f>."
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:husbandry/safely_harvest_honey]>:
                    - narrate "<server.flag[pfx_jett]><&f> Well done! I can see you're a busy bee."
                    - zap 4
                - else:
                    - narrate "<server.flag[pfx_jett]><&f> Have you tried to <&hover[<&a>[Gently harvest honey with a campfire]]><&6>beefriend the bees<&end_hover><&f>?"

        # main - job handout script
        4:
            click trigger:
                script:
                # this jobs PAPI returns True with a color tag instead of a boolean, so here's the workaround
                - if <placeholder[jobsr_user_isin_Quartermaster].contains_text[True]>:
                    - narrate "<server.flag[pfx_jett]><&f> Give a go at brewing when you have the time."
                - else:
                    - narrate "<server.flag[pfx_jett]><&f> Would you like to become a Quartermaster? \n<&8><&o>Respond with: <&hover[<&a>[Become a Quartermaster]]><&8><element[[Yes]].on_click[/denizenclickable chat Yes]><&end_hover>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[pfx_jett]><&f> You must leave a job before you can become a Quartermaster <&hover[[<&8>/jobs leave]]><&8><element[/jobs leave].on_click[/jobs leave ].type[SUGGEST_COMMAND]><&end_hover>"
                    - else:
                        - jobs join Quartermaster
                        - narrate "<&9>You have been employed as a Quartermaster. Welcome to the Keepers of the Vault!"
                        - wait 2s
                        - narrate "<server.flag[pfx_jett]><&f> The Vault awaits you, Quartermaster."