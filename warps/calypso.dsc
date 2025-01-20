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
                - cooldown 16s
                - narrate "<server.flag[pfx_calypso]><&f> Hello Trailblazer! Welcome aboard!"
                - wait 2
                - narrate "<server.flag[pfx_calypso]><&f> I'm Calypso, the captain of the Coldest Hot Air Balloon! <player.name> is it?"
                - wait 6
                - narrate "<server.flag[pfx_calypso]><&f> I'm on a gold run, heading to the Windspire Cove; home of the March of Progress!"
                - wait 5
                - narrate "<server.flag[pfx_calypso]><&f> We're leaving now, you're welcome to join if you'd like. <server.flag[npc_dialogue_yes]>"
                - zap 2

        #free warp script
        2:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_calypso]><&f> We're leaving to the Windspire Cove now, want to come along? <server.flag[npc_dialogue_yes]>"

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
                - cooldown 4s
                - narrate "<server.flag[pfx_calypso]><&f> <player.name>! You've the air of a Trailblazer. Come venture to the beyond with us!"
                - wait 1s
                - narrate "<server.flag[pfx_calypso]><&f> The fare is a mere 500 coins, would you like to depart? <server.flag[npc_dialogue_yesno]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    script:
                    - if <player.money> >= 500:
                        - narrate "<server.flag[pfx_calypso]><&f> Enjoy the ride!"
                        - money take quantity:500 players:<player>
                        - run calypso_tp
                    - else:
                        - define temp 500
                        - narrate "<server.flag[pfx_calypso]><&f> Sorry, you need another <[temp].sub[<player.money>].round_up> coins."
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                        - narrate "<server.flag[pfx_calypso]><&f> No Problem Pal! I'll be here if you need me!"


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
            - narrate "<server.flag[pfx_calypso]><&f> Is it hot up here?.... Oh right, its a hot air balloon"
            - narrate "<server.flag[pfx_calypso]><&f> Look over there! It's the Windspire Cove"
            - narrate "<server.flag[pfx_calypso]><&f> Ready for Landing?"
            - narrate "<server.flag[pfx_calypso]><&f> Did I ever tell you i'm afraid of heights?"