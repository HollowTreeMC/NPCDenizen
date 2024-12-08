#Rune is the NPC which hands out the Sorcerer job, located on the portal island inside the brewery hall.
rune:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
    interact scripts:
    - rune_main

rune_main:
    type: interact
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Rune<&f>: Do you have an affinity for alchemy? You may join the Sorcerer's guild once you've brewed a potion."
                - zap 2
        #giving quests to the player
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:nether/brew_potion]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Rune<&f>: Ah! So you've brewed a potion... Perhaps you would do..."
                    - zap 3
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Rune<&f>: Come back once you've brewed a potion..."
        #job handout script
        3:
            click trigger:
                script:
                - if <player.has_advancement[jobsr_user_isin_[Sorcerer]]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Rune<&f>: Hello fellow Sorcerer. We should discuss potion brewing sometime."
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Rune<&f>: Would you like to join the guild and work as a Sorcerer? <&7><element[[Yes]].on_click[/denizenclickable chat Yes]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Rune<&f>: You must leave a job before you can become a Sorcerer. <&7>/jobs leave"
                    - else:
                        - jobs join Sorcerer
                        - narrate "You have been employed as a Sorcerer."
                        - wait 2s
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Rune<&f>: Do you feel the magic?"