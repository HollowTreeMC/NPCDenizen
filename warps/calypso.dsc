calypso:
    debug: false
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true radius:5
    interact scripts:
    - calypso_main

calypso_main:
    debug: false
    type: interact
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: Hello Explorer! Welcome aboard!"
                - wait 2
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calpyso<&f>: I'm Calypso, captain of the Coldest Hot Air Balloon, <player.name> is it?"
                - wait 6
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: I'm on a gold ore run, heading to the Explorer Island"
                - wait 5
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Astra<&f>: We're leaving now, you're welcome to join if you'd like. <&7><element[[Yes]].on_click[/denizenclickable chat Yes]>"
                - zap 2

        #free warp script
        2:
            click trigger:
                script:
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: We're leaving to the Explorer Island now, want to come along? <&7><element[[Yes]].on_click[/denizenclickable chat Yes]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                        - run calypso_tp
                        - zap 3

        #default pay for warp script
        3:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: <player.name>! You've the air of an explorer. Come venture to the beyond with us!"
                - wait 1s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: The fare is a mere 500 coins, would you like to depart?  <&7><element[[Yes]].on_click[/denizenclickable chat Yes]> <&7><element[[No]].on_click[/denizenclickable chat No]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    script:
                    - if <player.money> >= 500:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: Enjoy the ride!"
                        - money take quantity:500 players:<player>
                        - run calypso_tp
                    - else:
                        - define temp 500
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: Sorry, you need another <[temp].sub[<player.money>].round_up> coins."
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: No Problem Pal! I'll be here if you need me!"


calypso_tp:
    debug: false
    type: task
    script:
        - playsound <player> sound:item_elytra_flying
        - execute as_server "/effect <player.name> Blindness 5 255"
        - wait 1s
        - execute as_server "/warp <player.name> ExplorerIsland -s"
        - wait 2s
        - random:
            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: Is it hot up here?.... Oh right, its a hot air balloon"
            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: Look over there! It's Explorer Island"
            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: Ready for Landing?"
            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Calypso<&f>: Did I ever tell you i'm afraid of heights?"