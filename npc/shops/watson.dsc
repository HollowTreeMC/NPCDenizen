#this script is for the librarian in the grand archive
watson:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - watson_main

watson_main:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                - if <player.has_flag[npc_engaged]>:
                  - stop
                - flag player npc_engaged expire:10s
                - narrate "<server.flag[pfx_watson]><&f> Hello <placeholder[cmi_user_rank]>. Welcome to the library. There is much knowledge to be gained here. Even the leaderboard is here!"
                - wait 3
                - narrate "<server.flag[pfx_watson]><&f> I'd be shocked if you weren't here to a purchase a book. I have many novels available. Would you like to take a look? <server.flag[npc_dialogue_yesno]>"

                #chat trigger entry
                - zap 2
                - wait 15s
                - zap 1
                - if !<player.has_flag[npc_chatted]>:
                    - narrate "<server.flag[pfx_watson]><&f> Perhaps you are a writer?"

        2:
            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s
                    # Add novels to sell and guide books for free
                    - execute as_server "dm open librarybooks_menu <player.name>"
                2:
                    trigger: /no|na/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s
                    - narrate "<server.flag[pfx_watson]><&f> I understand. Some people would rather wait until the movie comes out."
                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_watson]><&f> I didn't quite get that..."
