npc_handler:
    type: world
    debug: false
    events:
        on scripts loaded:
        # SET PREFIX FLAGS
        - flag server pfx_chronarch:<&7>{<&color[#530179]>C<&color[#890079]>h<&color[#b70071]>r<&color[#dd0063]>o<&color[#f94051]>n<&color[#ff6f3b]>a<&color[#ff9f31]>r<&color[#ffc900]>c<&color[#f5f50a]>h<&7>}<&f>
        #   Job NPCs
        - flag server pfx_bulki:<&8>{<&f>Scrapper<&8>}<&sp><&6>Bulki<&f>:<&f>
        - flag server pfx_clark:<&8>{<&f>Trailblazer<&8>}<&sp><&6>Clark<&f>:<&f>
        - flag server pfx_cogsworth:<&8>{<&f>Tinkerer<&8>}<&sp><&6>Cogsworth<&f>:<&f>
        - flag server pfx_elara:<&8>{<&f>Bladewarden<&8>}<&sp><&6>Elara<&f>:<&f>
        - flag server pfx_jett:<&8>{<&f>Quartermaster<&8>}<&sp><&6>Jett<&f>:<&f>
        - flag server pfx_rune:<&8>{<&f>Runeweaver<&8>}<&sp><&6>Rune<&f>:<&f>
        - flag server pfx_sterling:<&8>{<&f>Artificer<&8>}<&sp><&6>Sterling<&f>:<&f>

        #   Warp NPCs
        - flag server pfx_astra:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Astra<&f>:<&f>
        - flag server pfx_calypso:<&8>{<&f>Trailblazer<&8>}<&sp><&6>Calypso<&f>:<&f>
        - flag server pfx_ender:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Ender<&f>:<&f>
        - flag server pfx_ignis:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Ignis<&f>:<&f>
        - flag server pfx_lewis:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Lewis<&f>:<&f>
        - flag server pfx_vacuus:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Vacuus<&f>:<&f>
        - flag server pfx_the_duke:<&l><&Color[#5c4466]>T<&Color[#80708f]>h<&Color[#a0a0a0]>e<&sp><&Color[#b0b0b0]>D<&Color[#a0a0a0]>u<&Color[#80708f]>k<&Color[#6e567a]>e<&f>:<&f>

        #   Tutorial NPCs
        - flag server pfx_tutorial:<&7>[<&f>Tutorial<&7>]<&sp>
        - flag server pfx_cali:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Cali<&f>:<&f>
        - flag server pfx_kirra:<&f>[<&3>Ki<&b>rr<&f>a]:<&f>

        #   Misc NPCs
        - flag server pfx_fischer:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Fischer<&f>:<&f>
        - flag server pfx_juniper:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Juniper<&f>:<&f>
        - flag server pfx_xur:<&8>{<&f>Black<&sp>Marketeer<&8>}<&sp><&6>Xûr<&f>:<&f>
        - flag server pfx_ladyvalvewright:<server.flag[pfx_chronarch]><&sp><&6>Lady<&sp>Valvewright<&f>:<&f>
        - flag server pfx_ladymarina:<server.flag[pfx_chronarch]><&sp><&6>Lady<&sp>Marina<&f>:<&f>
        - flag server pfx_Nara:<&6>Mechanic<&sp>Nara<&f>:<&f>
        - flag server pfx_lordwestwood:<server.flag[pfx_chronarch]><&sp><&6>Lord<&sp>Westwood<&f>:<&f>

        #   Trial NPCs
        - flag server pfx_roland:<&8>{<&f>Aeronaut<&8>}<&sp><&6>Roland<&f>:<&f>


        # NPC HELPERS
        - flag server npc_dialogue_okay:<n><&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Okay<&7>]].on_click[/denizenclickable chat Yes]><&end_hover>
        - flag server npc_dialogue_yes:<n><&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Yes<&7>]].on_click[/denizenclickable chat Yes]><&end_hover>
        - flag server npc_dialogue_yesno:<n><&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Yes<&7>]].on_click[/denizenclickable chat Yes]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>No<&7>]].on_click[/denizenclickable chat No]><&end_hover>
        - flag server npc_dialogue_leavejob:<&7><&o>→<&sp><&hover[<&7>autofill command]><element[/jobs leave ].on_click[/jobs leave ].type[SUGGEST_COMMAND]><&end_hover>

        #   Xur NPC
        - if <util.time_now.day_of_week> == 1 || <util.time_now.day_of_week> == 5:
            - run xur_shop
        # Event
        - flag server eventTag:<&7>[<&3>Event<&7>]<&b>
        # Info
        - flag server infoTag:<&b>[<&3>!<&7><&b>]<&r><&sp>