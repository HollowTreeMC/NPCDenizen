#this script is for arlo, the bard at the brewery
arlo:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
    interact scripts:
    - arlo_main

arlo_main:
    type: interact
    debug: false
    steps:
        #first time meeting the NPC
        1:
            click trigger:
                script:
                - flag <player> npc_chatted expire:3s
                - if !<player.has_flag[npc-chatted]>:
                    - narrate "<server.flag[pfx_arlo]><&f> Songs for sigils! One sigil for five plays! <server.flag[npc_dialogue_okay]>"
            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[tne_currency_Sigils]> >= 1:
                        - execute as_server "money take <player.name> 1 Sigils"
                        - flag <player> arlo_plays:5
                        - zap 2
                    - else:
                        - narrate "<server.flag[pfx_arlo]><&f> Maintaining these jukeboxes isn't free, y'know. Come back when you can afford more plays"
        # Player has purchased plays
        2:
            click trigger:
                script:
                # player is out of plays
                - if <player.flag[arlo_plays]> <= 0:
                    - cooldown 3s
                    - narrate "<server.flag[pfx_arlo]><&f> Songs for sigils! One sigil for five plays! <server.flag[npc_dialogue_okay]>"
                    - zap 1

                # player has plays remaining
                - else:
                    # Check to see if arlo is currently playing a song
                    - if <server.has_flag[arlo_playing]>:
                        - narrate "<server.flag[pfx_arlo]><&f> Currently playing <server.flag[arlo_queue].get[2]> for another <server.flag_expiration[arlo_playing].from_now.in_seconds.round_up> seconds"
                    - else:
                        - narrate "<server.flag[pfx_arlo]><&f> What can I play for you? <&o>(<player.flag[arlo_plays]> plays left)"
                        - narrate "<&7><&o> → Respond in chat with the name of a music disc"
                        - zap 3
                        - wait 15s
                        - zap 2
                        - if !<player.has_flag[npc_chatted]>:
                            - narrate "<server.flag[pfx_arlo]><&f> Not sure yet? Come back when you pick one!"

        # Arlo's chat trigger
        3:
            chat trigger:
                1:
                    trigger: /Blocks|Cat|Chirp|Creator|Far|Mall|Mellohi|Otherside|Pigstep|Precipice|Relic|Stal|Strad|Wait|Ward/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag <player> npc_chatted expire:15s

                    # Player is out of plays
                    - if <player.flag[arlo_plays]> <= 0:
                        - zap 1

                    # Check to see if arlo is currently playing a song
                    - if <server.has_flag[arlo_playing]>:
                        - narrate "<server.flag[pfx_arlo]><&f> Currently playing <server.flag[arlo_queue].get[2]> for another <server.flag_expiration[arlo_playing].from_now.in_seconds.round_up> seconds"
                    - else:
                        # Arlo is not playing a song, playing new song, announce the new song to nearby players
                        - random:
                            - narrate "<server.flag[pfx_arlo]><&f> Alright <player.name>, <context.keyword> coming right up!" targets:<npc.location.find_players_within[30]>
                            - narrate "<server.flag[pfx_arlo]><&f> Good choice <player.name>, <context.keyword> it is" targets:<npc.location.find_players_within[30]>
                            - if true:
                                - narrate "<server.flag[pfx_arlo]><&f> Jett, if I have to play <context.keyword> one more time..." targets:<npc.location.find_players_within[30]>
                                - wait 2s
                                - narrate "<server.flag[pfx_arlo]><&f> Oh hey <player.name>! Happy to play <context.keyword> (〜￣▽￣)〜" targets:<npc.location.find_players_within[30]>
                        - playsound <npc.location> sound:music_disc_<context.keyword>

                        # timeout handler to prevent players from playing a song over another
                        - if <context.keyword> == Blocks:
                            - flag server arlo_queue:<list[343|Blocks]>
                        - if <context.keyword> == Cat:
                            - flag server arlo_queue:<list[185|Cat]>
                        - if <context.keyword> == Chirp:
                            - flag server arlo_queue:<list[185|Chirp]>
                        - if <context.keyword> == Creator:
                            - flag server arlo_queue:<list[176|Creator]>
                        - if <context.keyword> == Far:
                            - flag server arlo_queue:<list[174|Far]>
                        - if <context.keyword> == Mall:
                            - flag server arlo_queue:<list[197|Mall]>
                        - if <context.keyword> == Mellohi:
                            - flag server arlo_queue:<list[96|Mellohi]>
                        - if <context.keyword> == Otherside:
                            - flag server arlo_queue:<list[195|Otherside]>
                        - if <context.keyword> == Pigstep:
                            - flag server arlo_queue:<list[148|Pigstep]>
                        - if <context.keyword> == Precipice:
                            - flag server arlo_queue:<list[299|Precipice]>
                        - if <context.keyword> == Relic:
                            - flag server arlo_queue:<list[219|Relic]>
                        - if <context.keyword> == Stal:
                            - flag server arlo_queue:<list[150|Stal]>
                        - if <context.keyword> == Strad:
                            - flag server arlo_queue:<list[189|Strad]>
                        - if <context.keyword> == Wait:
                            - flag server arlo_queue:<list[237|Wait]>
                        - if <context.keyword> == Ward:
                            - flag server arlo_queue:<list[251|Ward]>

                        # set currently playing flag, decriment player's plays left, and run effects
                        - flag server arlo_playing expire:<server.flag[arlo_queue].get[1]>s
                        - flag <player> arlo_plays:--
                        - ~run arlo_effects

                2:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag <player> npc_chatted expire:15s

                    - narrate "<server.flag[pfx_arlo]><&f> Don't think we have that one here, I'm afraid..."

arlo_effects:
    type: task
    debug: false
    script:
    - while <server.has_flag[arlo_playing]>:
        - playeffect effect:Note at:<npc[19].location.add[0,1,0]>
        - wait 0.3s