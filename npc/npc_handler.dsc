npc_handler:
    type: world
    debug: false
    events:
        on scripts loaded:
        ## SET PREFIX FLAGS
        - define pfxL:<&7>⎱
        - define pfxR:<&7>⎱
        - flag server pfx_chronarch:<[pfxL]>{<&color[#530179]>C<&color[#890079]>h<&color[#b70071]>r<&color[#dd0063]>o<&color[#f94051]>n<&color[#ff6f3b]>a<&color[#ff9f31]>r<&color[#ffc900]>c<&color[#f5f50a]>h<&7>}<&f>

        #   Job NPCs
        - flag server pfx_bulki:<[pfxL]><&f>Scrapper<[pfxL]><&6>Bulki<&f>:<&f>
        - flag server pfx_clark:<[pfxL]><&f>Trailblazer<[pfxR]><&6>Clark<&f>:<&f>
        - flag server pfx_cogsworth:<[pfxL]><&f>Tinkerer<[pfxR]><&6>Cogsworth<&f>:<&f>
        - flag server pfx_elara:<[pfxL]><&f>Bladewarden<[pfxR]><&6>Elara<&f>:<&f>
        - flag server pfx_jett:<[pfxL]><&f>Quartermaster<[pfxR]><&6>Jett<&f>:<&f>
        - flag server pfx_rune:<[pfxL]><&f>Runeweaver<[pfxR]><&6>Rune<&f>:<&f>
        - flag server pfx_sterling:<[pfxL]><&f>Artificer<[pfxR]><&6>Sterling<&f>:<&f>

        #   Warp NPCs
        - flag server pfx_astra:<[pfxL]><&f>Aeronaut<[pfxR]><&6>Astra<&f>:<&f>
        - flag server pfx_calypso:<[pfxL]><&f>Trailblazer<[pfxR]><&6>Calypso<&f>:<&f>
        - flag server pfx_ender:<[pfxL]><&f>Aeronaut<[pfxR]><&6>Ender<&f>:<&f>
        - flag server pfx_ignis:<[pfxL]><&f>Aeronaut<[pfxR]><&6>Ignis<&f>:<&f>
        - flag server pfx_lewis:<[pfxL]><&f>Aeronaut<[pfxR]><&6>Lewis<&f>:<&f>
        - flag server pfx_vacuus:<[pfxL]><&f>Aeronaut<[pfxR]><&6>Vacuus<&f>:<&f>


        #   Tutorial NPCs
        - flag server pfx_tutorial:<&7>[<&f>Tutorial<&7>]<&sp>
        - flag server pfx_cali:<[pfxL]><&f>Aeronaut<[pfxR]><&6>Cali<&f>:<&f>
        - flag server pfx_kirra:<[pfxL]><&3>Ki<&b>rr<&f>a<[pfxR]>:<&f>

        #   Shop NPCs
        - flag server pfx_xur:<[pfxL]><&f>Black<&sp>Marketeer<[pfxR]><&6>Xûr<&f>:<&f>
        - flag server pfx_ladyvalvewright:<server.flag[pfx_chronarch]><&sp><&6>Lady<&sp>Valvewright<&f>:<&f>
        - flag server pfx_ladymarina:<server.flag[pfx_chronarch]><&sp><&6>Lady<&sp>Marina<&f>:<&f>
        - flag server pfx_lordwestwood:<server.flag[pfx_chronarch]><&sp><&6>Lord<&sp>Westwood<&f>:<&f>
        - flag server pfx_the_duke:<&l><&Color[#5c4466]>T<&Color[#80708f]>h<&Color[#a0a0a0]>e<&sp><&Color[#b0b0b0]>D<&Color[#a0a0a0]>u<&Color[#80708f]>k<&Color[#6e567a]>e<&f>:<&f>

        #   Trial NPCs
        - flag server pfx_roland:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Roland<&f>:<&f>


        #   Misc NPCs
        - flag server pfx_arlo:<[pfxL]><&f>Bard<[pfxR]><&6>Arlo<&f>:<&f>
        - flag server pfx_fischer:<[pfxL]><&f>Aeronaut<[pfxR]><&6>Fischer<&f>:<&f>
        - flag server pfx_juniper:<[pfxL]><&f>Aeronaut<[pfxR]><&6>Juniper<&f>:<&f>
        - flag server pfx_Nara:<&6>Mechanic<&sp>Nara<&f>:<&f>
        - flag server pfx_the_duke:<&Color[#5c4466]>T<&Color[#80708f]>h<&Color[#a0a0a0]>e<&sp><&Color[#b0b0b0]>D<&Color[#a0a0a0]>u<&Color[#80708f]>k<&Color[#6e567a]>e<&f>:<&f>

        #   Trial NPCs
        - flag server pfx_roland:<[pfxL]><&f>Aeronaut<[pfxR]><&6>Roland<&f>:<&f>

        # NPC HELPERS
        - flag server npc_dialogue_okay:<n><&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Okay<&7>]].on_click[/denizenclickable chat Yes]><&end_hover>
        - flag server npc_dialogue_yes:<n><&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Yes<&7>]].on_click[/denizenclickable chat Yes]><&end_hover>
        - flag server npc_dialogue_yesno:<n><&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Yes<&7>]].on_click[/denizenclickable chat Yes]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>No<&7>]].on_click[/denizenclickable chat No]><&end_hover>
        - flag server npc_dialogue_leavejob:<n><&7><&o>→<&sp><&hover[<&7>autofill command]><element[/jobs leave ].on_click[/jobs leave ].type[SUGGEST_COMMAND]><&end_hover>

        #   Xur NPC
        - if <util.time_now.day_of_week> == 1 || <util.time_now.day_of_week> == 5:
            - run xur_shop

        ## LOCATION / NPC INTEREST FLAGS
        # <&hover[HOVER TEXT]><element[TEXT].on_click[URL TEXT].type[OPEN_URL]><&end_hover>
        - flag server loc_StellarGallery:<&hover[<&7><&o>Speak to <&6>Astra <&7><&o>at /spawn!]><element[<&6>Stellar<&sp>Gallery].on_click[https://wiki.hollowcraft.net/Stellar_Gallery].type[OPEN_URL]><&end_hover>
        - flag server loc_ShatterpointIsle:<&hover[<&7><&o>Speak to <&6>Ender <&7><&o>at /spawn!]><element[<&6>Shatterpoint <&sp>Isle].on_click[https://wiki.hollowcraft.net/Shatterpoint_Isle].type[OPEN_URL]><&end_hover>
        - flag server loc_WindspireCove:<&hover[<&7><&o>Speak to <&6>Calypso <&7><&o>at /spawn!]><element[<&6>Windspire <&sp>Cove].on_click[https://wiki.hollowcraft.net/Windspire_Cove].type[OPEN_URL]><&end_hover>


        ## PLUGIN / SERVER EVENT FLAGS
        # Event
        - flag server eventTag:<&7>[<&3>Event<&7>]<&b>
        - flag server inviteTag:<&8>[<&a>🌲<&8>]

        # Info
        - flag server infoTag:<&b>[<&3>!<&7><&b>]<&r><&sp>
        - flag server voteTag:<&hover[<&7>/vote]><element[<&7>[<&b>✨<&7>]].on_click[/vote ].type[SUGGEST_COMMAND]><&f><&end_hover>

