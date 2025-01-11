#ladyvalvewright is the NPC informs the player whether or not they are allowed to use the adminmart, found in the adminmart storefront in Spawn.
ladyvalvewright:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
    interact scripts:
    - ladyvalvewright_main

ladyvalvewright_main:
    type: interact
    steps:
        # NPC intro
        1:
            click trigger:
                script:
                - cooldown 11s
                - narrate "<server.flag[pfx_ladyvalvewright]><&f> Ah! Welcome to the ChronoTech Emporium. You may address me as Lady Valvewright."
                - wait 3
                - narrate "<server.flag[pfx_ladyvalvewright]><&f> Here, you'll find any block you can imagine, which you can access with a pass!"
                - wait 5
                - narrate "<server.flag[pfx_ladyvalvewright]><&f> Those who have achieved the title of <server.flag[pfx_chronarch]> are permitted to purchase a pass."
                - zap 2

        # Pass handler
        2:
            click trigger:
                script:
                - cooldown 3s
                # player already has the pass
                - if <player.has_permission[cmi.command.portal.adminshop]>:
                    - narrate "<server.flag[pfx_ladyvalvewright]><&f> Your pass is valid. Enjoy the Emporium!"
                # player does not have the pass
                - else:
                    # player meets the requisite rank or balance
                    - if <player.has_permission[group.chronarch]> || <player.money> > 1000000:
                        - narrate "<server.flag[pfx_ladyvalvewright]><&f> Wonderful! With your status, you may purchase a temporary emporium pass!"
                        - wait 2
                        - narrate "<server.flag[pfx_ladyvalvewright]><&f> Would like to purchase a pass? For 5,000 coins, you can purchase a 1-week pass! <server.flag[npc_dialogue_yesno]>"

                        # chat trigger entry
                        - zap 3
                        - wait 15s
                        - zap 2
                        - if !<player.has_flag[npc_chatted]>:
                            - narrate "<server.flag[pfx_ladyvalvewright]><&f> I've business matters to attend to."
                    # player does not meet the requisite to purchase the pass
                    - else:
                        - narrate "<server.flag[pfx_ladyvalvewright]><&f> Ugh, you lack <&hover[<&a>Achieve the Chronarch rank]><&6>status and wealth<&end_hover><&f>! Return once you have progressed through the echelon!"

            3:
                chat trigger:
                    1:
                        trigger: /ye/ok/
                        hide trigger message: true
                        show as normal chat: false
                        script:
                        - flag player npc_chatted expire:15s
                        - if <player.has_permission[group.chronarch]> || <player.money> > 1000000:
                            - if <player.money> >= 5000:
                                - money take quantity:5000 players:<player>
                                - execute as_server "/lp user <player.name> permission settemp cmi.command.portal.adminshop 7d replace hollowtreeproject"
                                - wait 5
                                - narrate "<server.flag[pfx_ladyvalvewright]><&f> Your pass is now valid. Enjoy the Emporium!"
                            - else:
                                - define temp 5000
                                - narrate "<server.flag[pfx_ladyvalvewright]><&f> Your esteemed self, another <[temp].sub[<player.money>].round_up> coins are required."
                    2:
                        trigger: /no|na/
                        hide trigger message: true
                        show as normal chat: false
                        script:
                        - flag player npc_chatted expire:15s
                        - narrate "<server.flag[pfx_ladyvalvewright]><&f> Be sure to purchase your pass to enjoy our emporium!"
                    3:
                        trigger: /*/
                        hide trigger message: true
                        show as normal chat: false
                        script:
                        - narrate "<server.flag[pfx_ladyvalvewright]><&f> I don't understand"