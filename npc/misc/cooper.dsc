cooper:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - cooper_main

cooper_main:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                    - cooldown 3s
                    - narrate "<server.flag[pfx_cooper]><&f> Welcome to the Nether"