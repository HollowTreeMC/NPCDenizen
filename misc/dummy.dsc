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
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - ratelimit <player> 5s
                - if <util.random_chance[95]>:
                    - narrate "<&8>You think to yourself, <&f>'Why am I trying to talk to a dummy?'"
                - else:
                    - narrate "<&7>Dummy: <&f>Hey, watch the face! Oh wait... never mind."