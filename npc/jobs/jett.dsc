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
    debug: false
    steps:
        # npc intro
        1:
            click trigger:
                script:
                - cooldown 6s
                - narrate "<server.flag[pfx_jett]><&f> Hey there, I'm Jett, master Brewer and Quartermaster."
                - wait 3
                - narrate "<server.flag[pfx_jett]><&f> Give me a holla if you'd like to join the Keepers of the Vault as a Quartermaster."
                - zap 2

        # give quest
        2:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_jett]><&f> A good Quartermaster needs to know how to <&hover[<&a>[Gently harvest honey with a campfire]]><&6>harvest honey safely<&end_hover><&f>."
                - zap 3

        # check quest
        3:
            click trigger:
                script:
                - cooldown 3s
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
                    - narrate "<server.flag[pfx_jett]><&f> Would you like to become a Quartermaster? <server.flag[npc_dialogue_yesno]>"

                    # activate chat trigger, response if the player hasn't selected a response - this acts as a cooldown
                    - zap 5
                    - wait 15s
                    - zap 4
                    - if !<player.has_flag[npc_chatted]>:
                        - narrate "<server.flag[pfx_jett]><&f> Haha! Well Met!"

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
                        - narrate "<server.flag[pfx_jett]><&f> You must leave a job before you can become a Quartermaster <server.flag[npc_dialogue_leavejob]>"
                    - else:
                        - jobs join Quartermaster
                        - narrate "<&9>You have been employed as a Quartermaster. Welcome to the Keepers of the Vault!"
                        - narrate "<server.flag[pfx_jett]><&f> The Vault awaits you, Quartermaster."
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s
                    - narrate "<server.flag[pfx_jett]><&f> See you around."
                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_jett]><&f> What's that?"