#this script is for astra the dummy clone
dummy_explorer:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - dummy_explorer_main

dummy_explorer_main:
    type: interact
    debug: false
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - cooldown 3s
                - if <util.random_chance[90]>:
                    - narrate "<&8>You think to yourself, <&f>'Why am I trying to talk to a dummy?'"
                - else:
                    - narrate "<&7>Dummy: <&f>Hey, watch the face! Oh wait... never mind."