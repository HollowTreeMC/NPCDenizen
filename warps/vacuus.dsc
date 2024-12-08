vacuus:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - vacuus_main

vacuus_main:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Vacuus<&f>: For only 250 coins, I'll make it a random teleport. Want to? <&7><element[[Yes]].on_click[/denizenclickable chat Yes]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    script:
                    - if <player.money> >= 250:
                        - money take quantity:250 players:<player>
                        - random:
                            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Vacuus<&f>: Wait until you see the end of this!"
                            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Vacuus<&f>: Oh the places you can go! You chose here I guess..."
                            - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Vacuus<&f>: Can you hear the dragon roar?"
                        - execute as_server "/effect <player.name> Blindness 3 255"
                        - execute as_server "/rt <player.name> Hollowtree_the_end"
                    - else:
                        - define temp 250
                        - narrate "<&7>{<&f>Aeronaut<&7>}<&6>Vacuus<&f>: Sorry, you need another <[temp].sub[<player.money>]> coins."
