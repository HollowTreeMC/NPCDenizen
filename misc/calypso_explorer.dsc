#this script is for astra the calypso clone at the explorer island
calypso_explorer:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - calypso_explorer_main

calypso_explorer_main:
    type: interact
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 5s
                - random:
                    - narrate "<server.flag[pfx_calypso]><&f> Land Ho! The Explorer's Guild"
