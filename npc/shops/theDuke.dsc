theduke:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - theduke_main

theduke_main:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                - cooldown 5s
                - if <player.has_flag[eventPackage]>:
                    - narrate "<server.flag[pfx_the_duke]><&f> You have already purchased this package. Please return tomorrow."
                - else:
                    - narrate "<server.flag[pfx_the_duke]><&f> Would you like to purchase the event package for 2 sigils? <server.flag[npc_dialogue_yesno]>"
            chat trigger:
                Yes:
                    trigger: /ye|ok/
                    hide trigger message: true
                    script:
                    - if !<player.has_flag[firstEventPackage]>:
                      - narrate "<server.flag[pfx_the_duke]><&f> Good luck! First one's on the house!"
                      - flag player firstEventPackage
                      - execute as_op "cmi kit Event"
                      - stop
                    - if <player.has_flag[eventPackage]>:
                        - narrate "You already got this package today. Come back tomorrow."
                        - stop
                    - ^flag <player> eventPackage duration:18h
                    - if <placeholder[tne_currency_sigils]> >= 2:
                        - execute as_server "money take <player.name> 2 sigils"
                        - random:
                            - narrate "<server.flag[pfx_the_duke]><&f> There you are my good... human."
                            - narrate "<server.flag[pfx_the_duke]><&f> Here's you stuff, now get to it."
                            - narrate "<server.flag[pfx_the_duke]><&f> Here, some stuff. Now get lost."
                        - execute as_server "cmi kit Event <player.name>"
                        - narrate "<dark_aqua>[<aqua>!<dark_aqua>] <reset>The event package was added to your inventory!"
                    - else:
                        - define temp 250
                        - narrate "<server.flag[pfx_the_duke]><&f> You'll need more sigils for that. It appears that you only have <placeholder[tne_currency_sigils]>."
                No:
                    trigger: /no|n/
                    hide trigger message: true
                    script:
                    - narrate "<server.flag[pfx_the_duke]><&f> Off you go then."