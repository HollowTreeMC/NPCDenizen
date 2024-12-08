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
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: Where did I put my compass? Oh hello <player.name>. Would you like to work as a tinkerer? Crafters, crafters, crafters is the key."
                - zap 2
        #giving quests to the player
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:adventure/crafters_crafting_crafters]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: But of course! With a crafter! You're the one."
                    - zap 3
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: How would a crafter craft a crafter?"
        #job handout script
        3:
            click trigger:
                script:
                - if <player.has_advancement[jobsr_user_isin_[Tinkerer]]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: What did the differential gear tell the spigot? Hahahaha!"
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: Would you like to join the guild and work as a Sorcerer? <&7><element[[Yes]].on_click[/denizenclickable chat Yes]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: Dearie me, you're too involved to become a Tinkerer. <&7>/jobs leave"
                    - else:
                        - jobs join Tinkerer
                        - narrate "You have been employed as a Tinkerer."
                        - wait 2s
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Cogsworth<&f>: I know you'll make wonderful contraptions!"