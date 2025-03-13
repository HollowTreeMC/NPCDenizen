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
    debug: false
    steps:
        #first time meeting the NPC, Intro + Option to TP for free
        1:
            click trigger:
                script:
                - cooldown 16s
                - narrate "<server.flag[pfx_astra]><&f> Hello! Welcome aboard!"
                - wait 2
                - narrate "<server.flag[pfx_astra]><&f> I'm Astra, Captain of the Guilded, whose deck you're standing on. <player.name> is it?"
                - wait 6
                - narrate "<server.flag[pfx_astra]><&f> We've got precious cargo today, bound for the smeltery on the Portal Island."
                - wait 5
                - clickable astra_tp for<player> until:1m
                - narrate "<server.flag[pfx_astra]><&f> We're leaving now, you're welcome to join if you'd like. <server.flag[npc_dialogue_okay]>"
                - zap 2
        #free warp script, if a player does not TP initially, they possess 1 free TP
        2:
            click trigger:
                script:
                - cooldown 3s
                - narrate "<server.flag[pfx_astra]><&f> We're leaving to the Portal Island now, want to come along? <server.flag[npc_dialogue_yes]>"

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
                - cooldown 3s
                - narrate "<server.flag[pfx_astra]><&f> <player.name>! Want to go to the portal island? I can take you for 500 coins. <server.flag[npc_dialogue_yesno]>"

            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <player.money> >= 500:
                        - narrate "<server.flag[pfx_astra]><&f> Pleasure doing business. Let's set sail!"
                        - money take quantity:500 players:<player>
                        - run astra_tp
                    - else:
                        - define temp 500
                        - narrate "<server.flag[pfx_astra]><&f> I'll take you for another <[temp].sub[<player.money>].round_up> coins."
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_astra]><&f> No worries, you know where to find me!"

astra_tp:
    type: task
    debug: false
    script:
        - playsound <player> sound:item_elytra_flying
        - execute as_server "/effect <player.name> Blindness 5 255"
        - wait 1s
        - execute as_server "/warp <player.name> PortaLIsland -s"
        - wait 2s
        - random:
            - narrate "<server.flag[pfx_astra]><&f> Woohoo! To the smeltery!"
            - narrate "<server.flag[pfx_astra]><&f> Welcome to Portal Island! Time to offload all this gold ore..."
            - narrate "<server.flag[pfx_astra]><&f> These portals give me the creeps!"
            - narrate "<server.flag[pfx_astra]><&f> I heard Sterling is looking for apprentice smiths..."