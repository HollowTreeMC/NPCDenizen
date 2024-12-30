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
                - narrate "<server.flag[pfx_ladyvalvewright]><&f> Ah! Welcome to ChronoTech Emporium. You may address me as Lady Valvewright."
                - wait 5
                - narrate "<server.flag[pfx_ladyvalvewright]><&f> Here, you'll find anything and everything you can imagine. However, we do only currently supply blocks."
                - wait 5
                - narrate "<server.flag[pfx_ladyvalvewright]><&f> However, our services are not without cost! Only those who have achieved the title of <&6>Chronarch or higher <&f>are permitted to enter."
                - zap 2

        # Chronarch group check
        2:
            click trigger:
                script:
                - if <player.has_permission[group.chronarch]>:
                    - narrate "<server.flag[pfx_ladyvalvewright]><&f> Wonderful! With such a grand title, you may purchase a temporary entry pass!"
                    - wait 5
                    - narrate "<server.flag[pfx_ladyvalvewright]><&f> Would you be interested in purchasing a pass?   <&8><element[[Yes]].on_click[/denizenclickable chat Yes]> <&8><element[[No]].on_click[/denizenclickable chat No]>"
                - else:
                    - narrate "<server.flag[pfx_ladyvalvewright]><&f> Ugh, you lack <&hover[<&a>Achieve the rank Chronarch]><&6>prestige and status<&end_hover><&f>! Return once you have progressed through the echelon!"

                chat trigger:
                    1:
                        trigger: /ye/ok/
                        hide trigger message: true
                        script:
                        - execute as_server "dm open adminspass <player.name>"
                        - wait 5
                        - narrate "<server.flag[pfx_ladyvalvewright]><&f> Enjoy the Emporium!"
                    2:
                        trigger: /no|na/
                        hide trigger message: true
                        show as normal chat: false
                        script:
                        - narrate "<server.flag[pfx_ladyvalvewright]><&f> Be sure to purchase your pass to enjoy our emporium!"
