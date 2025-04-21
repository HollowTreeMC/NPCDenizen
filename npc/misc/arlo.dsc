#this script is for astra the arlo clone
arlo:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
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
                    - if <player.flag[arlo_plays]> <= 0:
                        - cooldown 3s
                        - narrate "<server.flag[pfx_arlo]><&f> Songs for sigils! One sigil for five plays! Just say the word. <server.flag[npc_dialogue_okay]>"
                        - zap 1
                    - else:
                        - narrate "<server.flag[pfx_arlo]><&f> What can I play for you? You've got <player.flag[arlo_plays]> songs left."

            chat trigger:
                1:
                    trigger: /Blocks|Cat|Chirp|Creator|Far|Mall|Mellohi|Otherside|Pigstep|Precipice|Relic|Stal|Strad|Wait|Ward/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - if <player.flag[arlo_plays]> <= 0:
                        - zap 1
                    - random:
                        - narrate "<server.flag[pfx_arlo]><&f> <context.keyword> coming right up!"
                        - narrate "<server.flag[pfx_arlo]><&f> I like your style, <context.keyword> it is"
                    - playsound <npc.location> sound:music_disc_<context.keyword>
                    - flag player arlo_plays:--

                2:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_arlo]><&f> Sorry I don't know that one"

