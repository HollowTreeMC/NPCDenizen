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
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Sterling<&f>: Who's there? We need more hands at the forge, forge an iron chestplate to prove your mettle."
                - zap 2
        #giving quests to the player
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:story/obtain_armor]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Sterling<&f>: Ah! A robust chestplate. Rough around the edgest, but it'll do..."
                    - zap 3
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Sterling<&f>: Come back once you've forged a chestplate..."
        #job handout script
        3:
            click trigger:
                script:
                - if <player.has_advancement[jobsr_user_isin_[Smith]]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Sterling<&f>: You'll get arms of steel in no time!"
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Sterling<&f>: Would you like to join the core and work as a Smith? <&7>[Yes]"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Sterling<&f>: You must leave a job before you can become a Smith. <&7>/jobs leave"
                    - else:
                        - jobs join Smith
                        - narrate "You have been employed as a Smith."
                        - wait 2s
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Sterling<&f>: Ha ha! Welcome another to the forge!"