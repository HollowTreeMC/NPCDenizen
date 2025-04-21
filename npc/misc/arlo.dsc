#this script is for astra the arlo clone
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
                - cooldown 3s
                - narrate "<server.flag[pfx_arlo]><&f> Songs for sigils! One sigil for five plays! <server.flag[npc_dialogue_okay]>"
            chat trigger:
                1:
                    trigger: /ye|ok/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <placeholder[tne_currency_Sigils]> >= 1:
                        - execute as_server "money take <player.name> 1 Sigils"
                        - flag player arlo_plays:5
                        - zap 2
                    - else:
                        - narrate "<server.flag[pfx_arlo]><&f> The notes don't come out of thin air ya'know."
        # Player has purchased plays
        2:
            click trigger:
                script:
                # player is out of plays
                - if <player.flag[arlo_plays]> <= 0:
                    - cooldown 3s
                    - narrate "<server.flag[pfx_arlo]><&f> Songs for sigils! One sigil for five plays! Just say the word. <server.flag[npc_dialogue_okay]>"
                    - zap 1
                # player has plays remaining
                - else:
                    - narrate "<server.flag[pfx_arlo]><&f> What can I play for you? You have <player.flag[arlo_plays]> plays"
                    - narrate "<&7><&o> → Respond in chat with a music disc name"
                    - zap 3
                    - wait 15s
                    - zap 2
                - if !<player.has_flag[npc_chatted]>:
                    - narrate "<server.flag[pfx_arlo]><&f> Hmm what's a midi?"
        # Arlo's chat trigger
        3:
            chat trigger:
                1:
                    trigger: /Blocks|Cat|Chirp|Creator|Far|Mall|Mellohi|Otherside|Pigstep|Precipice|Relic|Stal|Strad|Wait|Ward/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s

                    - if <player.flag[arlo_plays]> <= 0:
                        - zap 1

                    - if <server.has_flag[arlo_playing]>:
                        - narrate "<server.flag[pfx_arlo]><&f> <context.keyword> coming right up!"

                    # success, playing song
                    - random:
                        - narrate "<server.flag[pfx_arlo]><&f> <context.keyword> coming right up!"
                        - narrate "<server.flag[pfx_arlo]><&f> I like your style, <context.keyword> it is"
                    - playsound <npc.location> sound:music_disc_<context.keyword>

                    # timeout handler to prevent players from playing a song over another
                    - if <context.keyword> == Blocks:
                        - define duration <list[343|Blocks]>
                    - if <context.keyword> == Cat:
                        - define duration <list[185|Cat]>
                    - if <context.keyword> == Chirp:
                        - define duration <list[185|Chirp]>
                    - if <context.keyword> == Creator:
                        - define duration <list[176|Creator]>
                    - if <context.keyword> == Far:
                        - define duration <list[174|Far]>
                    - if <context.keyword> == Mall:
                        - define duration <list[197|Mall]>
                    - if <context.keyword> == Mellohi:
                        - define duration <list[96|Mellohi]>
                    - if <context.keyword> == Otherside:
                        - define duration <list[195|Otherside]>
                    - if <context.keyword> == Pigstep:
                        - define duration <list[148|Pigstep]>
                    - if <context.keyword> == Precipice:
                        - define duration <list[299|Precipice]>
                    - if <context.keyword> == Relic:
                        - define duration <list[219|Relic]>
                    - if <context.keyword> == Stal:
                        - define duration <list[150|Stal]>
                    - if <context.keyword> == Strad:
                        - define duration <list[189|Strad]>
                    - if <context.keyword> == Wait:
                        - define duration <list[237|Wait]>
                    - if <context.keyword> == Ward:
                        - define duration <list[251|Ward]>

                    - flag server arlo_playing expire:duration[1]


                        # play this effect in a seperate function as an async function ~
                        # effect:NOTE at:<npc[19].location>


                    - flag player arlo_plays:--

                2:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - flag player npc_chatted expire:15s

                    - narrate "<server.flag[pfx_arlo]><&f> Sorry I don't know that one"