rune:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
        - run runeformat
    interact scripts:
    - rune_main

runeFormat:
  type: task
  debug: false
  script:
  - if !<server.has_flag[rune]>:
    - flag server rune:<&7>{<&f>Aeronaut<&7>}<&6>Rune<&f>:<&sp>

rune_main:
    type: interact
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - run runeformat
                - ratelimit <player> 10s
                - narrate "<server.flag[rune]>Do you have an affinity for alchemy? You can take the Sorcerer's guild's test once you've brewed a potion."
                - zap 2
        #giving quests to the player
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - if <player.has_advancement[minecraft:brew_potion]>:
                    - narrate "<server.flag[rune]>Ah! So you've brewed a potion... Perhaps you would do..."
                    - zap 3
                - else:
                    - narrate "<server.flag[rune]>Come back once you've brewed a potion..."
        #job handout script
        3:
            click trigger:
                script:
                - narrate "<server.flag[rune]>Would you like to join the guild and work as a Sorcerer? <&7>[Yes]"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[jobsr_user_joinedjobcount]> >= <placeholder[jobsr_maxjobs]>:
                        - narrate "<server.flag[rune]>You must leave a job before you can become a Sorcerer."
                    - else:
                        - jobs join Sorcerer
                        - narrate "You have been employed as a Sorcerer."
                        - wait 2s
                        - narrate "<server.flag[rune]>Do you feel the magic?"