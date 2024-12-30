npc_handler:
    type: world
    debug: false
    events:
        on scripts loaded:
        # SET PREFIX FLAGS
        #   Job NPCs
        - flag server pfx_bulki:<&8>{<&f>Scrapper<&8>}<&sp><&6>Bulki<&f>:<&f>
        - flag server pfx_clark:<&8>{<&f>Explorer<&8>}<&sp><&6>Clark<&f>:<&f>
        - flag server pfx_cogsworth:<&8>{<&f>Tinkerer<&8>}<&sp><&6>Cogsworth<&f>:<&f>
        - flag server pfx_elara:<&8>{<&f>Fighter<&8>}<&sp><&6>Elara<&f>:<&f>
        - flag server pfx_jett:<&8>{<&f>Quartermaster<&8>}<&sp><&6>Jett<&f>:<&f>
        - flag server pfx_rune:<&8>{<&f>Smith<&8>}<&sp><&6>Sterling<&f>:<&f>
        - flag server pfx_sterling:<&8>{<&f>Sorcerer<&8>}<&sp><&6>Rune<&f>:<&f>
        #   Warp NPCs
        - flag server pfx_astra:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Astra<&f>:<&f>
        - flag server pfx_calypso:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Calypso<&f>:<&f>
        - flag server pfx_ender:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Ender<&f>:<&f>
        - flag server pfx_ignis:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Ignis<&f>:<&f>
        - flag server pfx_lewis:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Lewis<&f>:<&f>
        - flag server pfx_vacuus:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Vacuus<&f>:<&f>
        #   Tutorial NPCs
        - flag server pfx_tutorial:<&7>[<&f>Tutorial<&7>]<&sp>
        - flag server pfx_cali:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Cali<&f>:<&f>
        - flag server pfx_kirra:<&f>[<&3>Ki<&b>rr<&f>a]:<&f>

        #   Misc NPCs
        - flag server pfx_fischer:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Fischer<&f>:<&f>
        - flag server pfx_juniper:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Juniper<&f>:<&f>
        - flag server pfx_xur:<&8>{<&f>Black<&sp>Marketeer<&8>}<&sp><&6>Xûr<&f>:<&f>
        - flag server pfx_ladyvalvewright:<&8>{<&f>Chronarch<&8>}<&sp><&6>Lady<&sp>Valvewright<&f>:<&f>

        # NPC SETUPS
        #   Xur NPC
        #teleport xur to a specified location
        #set up the proper trades