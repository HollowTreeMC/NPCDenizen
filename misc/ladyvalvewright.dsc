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
        # npc intro
        1:
            click trigger:
                script:
                - narrate "<&8>{<&f>Chronarch<&8>} <&6>Lady Valvewright<&f>: Ah! Welcome to ChronoTech Emporium. You may address me as Lady Valvewright."
                - wait 5
                - narrate "<&8>{<&f>Chronarch<&8>} <&6>Lady Valvewright<&f>: Here, you'll find anything and everything you can imagine. However, we do only currently supply blocks."
                - wait 5
                - narrate "<&8>{<&f>Chronarch<&8>} <&6>Lady Valvewright<&f>: However, our services are not without cost! Onl those who have achieved the title of <&6>Chronarch or higher <&f>are permitted to enter."
                - zap 2

        # main - dialogue handout script
        2:
            click trigger:
                script:
                - if  <player.has_permission[group.chronarch]>:
                    - narrate "<&8>{<&f>Chronarch<&8>} <&6>Lady Valvewright<&f>: Wonderful! With such a grand title, you may enter our grand emporium."
                - else:
                    - narrate "<&8>{<&f>Chronarch<&8>} <&6>Lady Valvewright<&f>: Ugh, you lack <&6>prestige<&f> and <&6>status<&f>! Return once you have progressed through the echelon!"
