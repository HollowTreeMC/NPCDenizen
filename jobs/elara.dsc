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
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Elara<&f>: Want to become a fighter? First give a pillager a taste of their own medicine."
                - zap 2
        #giving quests to the player
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:adventure/whos_the_pillager_now]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Elara<&f>: Well done <player.name>! I knew you had the chops."
                    - zap 3
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Elara<&f>: Best a pillager by becoming one..."
        #job handout script
        3:
            click trigger:
                script:
                - if <player.has_advancement[jobsr_user_isin_[Fighter]]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Elara<&f>: Bested anyone in combat recently?"
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Elara<&f>: Become a fighter? <&7><element[[Yes]].on_click[/denizenclickable chat Yes]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Elara<&f>: You must leave a job before you can become a Fighter. <&7>/jobs leave"
                    - else:
                        - jobs join Fighter
                        - narrate "You have been employed as a Fighter."
                        - wait 2s
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Elara<&f>: The Goddess's blessings be with you."