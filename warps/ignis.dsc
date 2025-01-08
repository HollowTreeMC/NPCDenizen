ignis:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true radius:5
    interact scripts:
    - ignis_main

ignis_main:
    type: interact
    steps:
    	#first time meeting the NPC
        1:
            click trigger:
                script:
                - narrate "<server.flag[pfx_ignis]><&f> Well hello! I'm Ignis, Roamer of this realm."
                - wait 2
                - narrate "<server.flag[pfx_ignis]><&f> Adventuring through this realm for the first time are you?"
                - wait 4
                - narrate "<server.flag[pfx_ignis]><&f> Through this portal and you'll be taken through to the nether!"
                - zap 2
        #default pay for warp script
        2:
            click trigger:
                script:
                - ratelimit <player> 10s
                - narrate "<server.flag[pfx_ignis]><&f> I can take you a bit farther out in the Nether for a small fee, only 250 coins. \n<&8><&o>Respond with: <&8><element[[Yes]].on_click[/denizenclickable chat Yes]> <&8><element[[No]].on_click[/denizenclickable chat No]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    script:
                    - if <player.money> >= 250:
                        - money take quantity:250 players:<player>
                        - random:
                            - narrate "<server.flag[pfx_ignis]><&f> Watch out for the piglins."
                            - narrate "<server.flag[pfx_ignis]><&f> Bringing you to the hottest destination!"
                            - narrate "<server.flag[pfx_ignis]><&f> So happy you'll be, with your cobblestone tree."
                        - execute as_server "/effect <player.name> Blindness 3 255"
                        - execute as_server "/rt <player.name> Hollowtree_nether"
                    - else:
                        - define temp 250
                        - narrate "<server.flag[pfx_ignis]><&f> Sorry, you need another <[temp].sub[<player.money>].round_up> coins."

                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                        - narrate "<server.flag[pfx_ignis]><&f> No Problem Pal! I'll be here if you need me!"

Ignis_tp:
    type: task
    script:
        - playsound <player> sound:item_elytra_flying
        - execute as_server "/effect <player.name> Blindness 5 255"
        - wait 1s
        - execute as_server "/rt <player.name> Hollowtree_nether"
        - wait 2s
        - random:
            - narrate "<server.flag[pfx_ignis]><&f> It's a tad bit warm, why did I wear a sweater"
            - narrate "<server.flag[pfx_ignis]><&f> Was that some netherite?"