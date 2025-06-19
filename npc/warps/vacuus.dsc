vacuus:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true radius:5
    interact scripts:
    - vacuus_main

vacuus_main:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_vacuus]><&f> For only 250 coins, I'll make it a random teleport. Want to? <server.flag[npc_dialogue_yesno]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    script:
                    - if <player.money> >= 250:
                        - money take quantity:250 players:<player>
                        - random:
                            - narrate "<server.flag[pfx_vacuus]><&f> Wait until you see the end of this!"
                            - narrate "<server.flag[pfx_vacuus]><&f> Oh the places you can go! You chose here I guess..."
                            - narrate "<server.flag[pfx_vacuus]><&f> Can you hear the dragon roar?"
                        - execute as_server "/effect <player.name> Blindness 3 255"
                        - execute as_server "cmi rt <player.name> Hollowtree_the_end"
                    - else:
                        - define temp 250
                        - narrate "<server.flag[pfx_vacuus]><&f> Sorry, you need another <[temp].sub[<player.money>].round_up> coins."
