npc_handler:
    type: world
    debug: false
    events:
        on scripts loaded:
        # SET PREFIX FLAGS
        #   Job NPCs
        - flag server bulki:<&8>{<&f>Scrapper<&8>}<&sp><&6>Bulki<&f>:<&f>
        - flag server clark:<&8>{<&f>Explorer<&8>}<&sp><&6>Clark<&f>:<&f>
        - flag server cogsworth:<&8>{<&f>Tinkerer<&8>}<&sp><&6>Cogsworth<&f>:<&f>
        - flag server elara:<&8>{<&f>Fighter<&8>}<&sp><&6>Elara<&f>:<&f>
        - flag server jett:<&8>{<&f>Quartermaster<&8>}<&sp><&6>Jett<&f>:<&f>
        - flag server rune:<&8>{<&f>Smith<&8>}<&sp><&6>Sterling<&f>:<&f>
        - flag server sterling:<&8>{<&f>Sorcerer<&8>}<&sp><&6>Rune<&f>:<&f>
        #   Warp NPCs
        - flag server astra:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Astra<&f>:<&f>
        - flag server calypso:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Calypso<&f>:<&f>
        - flag server ender:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Ender<&f>:<&f>
        - flag server ignis:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Ignis<&f>:<&f>
        - flag server lewis:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Lewis<&f>:<&f>
        - flag server vacuus:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Vacuus<&f>:<&f>
        #   Misc NPCs
        - flag server fischer:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Fischer<&f>:<&f>
        - flag server juniper:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Juniper<&f>:<&f>
        - flag server xur:<&8>{<&f>Black<&sp>Marketeer<&8>}<&sp><&6>Xûr<&f>:<&f>

        # NPC SETUPS
        #   Xur NPC
        #teleport xur to a specified location
        #set up the proper trades