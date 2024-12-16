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
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Jett<&f>: A good quartermaster will know how to harvest honey safely."
                - zap 2
        #giving quests to the player
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:husbandry/safely_harvest_honey]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Jett<&f>: Well done! I can see you're a busy bee."
                    - zap 3
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Jett<&f>: Have you tried to beefriend the bees?"
        #job handout script
        3:
            click trigger:
                script:
                - if <placeholder[jobsr_user_isin_[Quartermaster]]> == yes:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Jett<&f>: Give a go at brewing when you have the time."
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Jett<&f>: Would you like to become a quartermaster? <&7><element[[Yes]].on_click[/denizenclickable chat Yes]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Jett<&f>: You must leave a job before you can become a Sorcerer. <&7>/jobs leave"
                    - else:
                        - jobs join Quartermaster
                        - narrate "You have been employed as a Quartermaster."
                        - wait 2s
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Jett<&f>: I can't wait to see what you cook up."