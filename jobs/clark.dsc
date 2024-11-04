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
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Clark<&f>: Ah, a newcomer! To join the Adventurers' Guild, you'll need to first respect the remnants..."
                - zap 2
        #giving quests to the player
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:brew_potion]>:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Clark<&f>: Well done! You've completed my quest. Impressive work!"
                    - zap 3
                - else:
                    - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Clark<&f>: It seems you haven't finished the quest yet. Don't worry; simply respect the remnants!"
        #job handout script
        3:
            click trigger:
                script:
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Clark<&f>: Would you like to join the ranks of the Explorers? <&7>[Yes]"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Clark<&f>: You have too many jobs!"
                    - else:
                        - jobs join Explorer
                        - narrate "You have been employed as an Explorer."
                        - wait 2s
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Clark<&f>: Welcome aboard! Hot air balloon not included, haha."