#this script is for astra, who will warp players to the portal island from spawn
astra:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true radius:5
    interact scripts:
    - astra_main

astra_main:
    type: interact
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: Hello scrapper! Welcome aboard!"
                - wait 2
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: I'm Astra, captain of the Guilded, whose deck you're standing on. <player.name> is it?"
                - wait 6
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: We've got precious cargo today, bound for the smeltery on the Portal Island."
                - wait 5
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: We're leaving now, you're welcome to join if you'd like. <&7>[Okay]"
                - zap 2
        #free warp script
        2:
            click trigger:
                script:
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: We're leaving to the Portal Island now, want to come along? <&7>[Yes]"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                        - run astra_tp
                        - zap 3
        #default pay for warp script
        3:
            click trigger:
                script:
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: <player.name>! Want to go to the portal island? I can take you for 500 coins. <&7>[Yes] [No]"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <player.money> >= 500:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: Pleasure doing business. Let's set sail!"
                        - money take quantity:500 players:<player>
                        - run astra_tp
                    - else:
                        - define temp 500
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: I'll take you for another <[temp].sub[<player.money>]> coins."
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: No worries, you know where to find me!"

astra_tp:
    type: task
    script:
        - playsound <player> sound:item_elytra_flying
        - execute as_server "/effect <player.name> Blindness 5 255"
        - wait 1s
        - execute as_server "/warp <player.name> PortaLIsland -s"
        - wait 2s
        - random:
            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: Woohoo! To the smeltery!"
            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: Welcome to Portal Island! Time to offload all this gold ore..."
            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: These portals give me the creeps!"
            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: I heard Sterling is looking for apprentice smiths..."