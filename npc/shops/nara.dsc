# This script is for daily login rewards from Nara at spawn
nara:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - nara_daily_quest

#New daily login rewards script with quests as requirement for rewards
nara_daily_quest:
    type: interact
    debug: true
    steps:

        # added introduction script
        1:
            click trigger:
                script:
                - ratelimit <player> 5s
                - narrate "<server.flag[pfx_nara]><&f>Hello <player.name>! I have been tasked to find players like yourself to give quests in exchange for Sigils and Keys! I have new quests every day so be sure to stop on by."
                - zap 2

        # daily quest script
        2:
            click trigger:
                script:
                - ratelimit <player> 5s
                #Check if player completed quest already today
                - if <player.has_flag[nara_daily]>:
                    #Has already completed quest today
                    - narrate "<server.flag[pfx_nara]><&f> Visit me tomorrow for a new quest!"

                #Zap to correct quest-type / start correct quest progress counter
                #nara_quest gets set only now, so the quest counter only starts to count now.
                - else:
                    - if <server.flag[nara_daily].get[1]> == item:
                        - narrate "<server.flag[pfx_nara]><&6> Bring me <server.flag[nara_daily].get[3]> <server.flag[nara_daily].get[2]>'s for your rewards today!"
                        - zap 3

                    - if <server.flag[nara_daily].get[1]> == kill:
                        - narrate "<server.flag[pfx_nara]><&6> Kill <server.flag[nara_daily].get[3]> <server.flag[nara_daily].get[2]>'s for your rewards today!"
                        - flag <player> nara_quest:<list[kill|0|active]>
                        - zap 4

                    - if <server.flag[nara_daily].get[1]> == breed:
                        - narrate "<server.flag[pfx_nara]><&6> Breed <server.flag[nara_daily].get[3]> baby <server.flag[nara_daily].get[2]>'s for your rewards today!"
                        - flag <player> nara_quest:<list[breed|0|active]>
                        - zap 5

# FORMAT NOTE: the format for this listag ("nara_quest") goes: nara_quest:<list[]"QUESTTYPE"|"PROGRESS"|"STATUS"]>  ; (3 ("STATUS") gets updated further down -> see Nara_quest_listener)


        # Quest completion script for quest type "item"
        3:
            click trigger:
                script:
                - ratelimit <player> 5s
                #Check if player has all items needed to complete the quest
                - if <player.inventory.quantity_item[<server.flag[nara_daily].get[2]>]> >= <server.flag[nara_daily].get[3]>:

                    #Hand out rewards
                    - narrate "<server.flag[pfx_nara]><&f> Here are your daily quest rewards! See you tomorrow for more!"
                    - take item:<server.flag[nara_daily].get[2]> quantity:<server.flag[nara_daily].get[3]>
                    - execute as_server 'crates givekey votinator <player.name> 4'
                    - execute as_server 'sigil give <player.name> 6'
                    - flag <player> nara_daily:1 expire:22h
                    - flag <player> nara_quest:!
                    - zap 2

                - else:
                    - narrate "<server.flag[pfx_nara]><&f> I see that you don't <&6>have enough goods yet. <&f>Come back when you have them all. As a reminder, you need to <&6>bring me <server.flag[nara_daily].get[3]> <server.flag[nara_daily].get[2]>'s"

        #When testing!: Zap to step 2 manually, when you get messages like "As a reminder, you still need to breed 15 creepers." /ex zap 2 script:nara_daily_quest
        # Quest completion script for quest type "kill"
        4:
            click trigger:
                script:
                - ratelimit <player> 5s
                #Check if player has completed the quest
                - if <player.flag[nara_quest].get[3]> == complete:

                    #Hand out rewards
                    - narrate "<server.flag[pfx_nara]><&f> Here are your daily quest rewards! See you tomorrow for more!"
                    - execute as_server 'crates givekey votinator <player.name> 4'
                    - execute as_server 'sigil give <player.name> 6'
                    - flag <player> nara_daily:1 expire:22h
                    - flag <player> nara_quest:!
                    - zap 2

                - else:
                    - narrate "<server.flag[pfx_nara]><&f> I see that you didn't <&6>kill enough <server.flag[nara_daily].get[2]>'s <&f>for your quest yet. Come back when got them all. As a reminder, you need to <&6>kill <server.flag[nara_daily].get[3]> <server.flag[nara_daily].get[2]>'s"

        # Quest completion script for quest type "breed"
        5:
            click trigger:
                script:
                - ratelimit <player> 5s
                #Check if player has completed the quest
                - if <player.flag[nara_quest].get[3]> == complete:

                    #Hand out rewards
                    - narrate "<server.flag[pfx_nara]><&f> Here are your daily quest rewards! See you tomorrow for more!"
                    - execute as_server 'crates givekey votinator <player.name> 4'
                    - execute as_server 'sigil give <player.name> 6'
                    - flag <player> nara_daily:1 expire:22h
                    - flag <player> nara_quest:!
                    - zap 2
                - else:
                    - narrate "<server.flag[pfx_nara]><&f> I see that you didn't <&6>breed enough baby <server.flag[nara_daily].get[2]>'s <&f>for your quest yet. Come back when got them all. As a reminder, you need to <&6>breed <server.flag[nara_daily].get[3]> baby <server.flag[nara_daily].get[2]>'s"

Nara_quest_listener:
    type: world
    debug: false
    events:
        on player kills entity flagged:nara_quest:
            #Check for quest type
            - if <player.flag[nara_quest].get[1]> == kill && <player.flag[nara_quest].get[3]> == active:

                #Check if entity killed is the correct type for the quest
                - if <context.entity.type> == <server.flag[nara_daily].get[2]>:

                    #Register and show progress
                    #Check if next progress will reach the goal - tried it *when* it reached it, but that didn't work due to timing? Doesn't read newest change quickly enough?
                    - if <player.flag[nara_quest].get[2].add[1]> >= <server.flag[nara_daily].get[3]>:
                        - flag <player> nara_quest:<list[<player.flag[nara_quest].get[1]>|<player.flag[nara_quest].get[2].add[1]>|complete]>
                        - narrate "<server.flag[pfx_nara]><&6> Your Progress: <&f><player.flag[nara_quest].get[2]>/<server.flag[nara_daily].get[3]> <&a>(Complete!)"
                        - stop

                    - else:
                        - flag <player> nara_quest:<list[<player.flag[nara_quest].get[1]>|<player.flag[nara_quest].get[2].add[1]>|active]>
                        - narrate "<server.flag[pfx_nara]><&6> Your Progress: <&f><player.flag[nara_quest].get[2]>/<server.flag[nara_daily].get[3]>"

        on entity breeds:
            # Check if player has quest flag (Did quest start?)
            # todo: modify this script in the future to only check for entity breed if the quest is active in this mode

            - if <context.breeder.is_player || false> && <context.breeder.has_flag[nara_quest]>:

                #define [player] to use in this event; to easily read the script, instead of <context.breeder>:
                - define player <context.breeder>

                #Check for quest type ; Use [], because it is a defined tag now, not a universal tag
                #Also check if quest is already completed, if not: prevent from counting higher than goal (server.flag[nara_daily].get[3])
                - if <[player].flag[nara_quest].get[1]> == breed && <[player].flag[nara_quest].get[3]> == active:

                    #Layer 3: Check if entity bred is the correct type for the quest
                    - if <context.child.type> == <server.flag[nara_daily].get[2]>:

                        #Register and show progress
                        #.Add "complete" to kill counter after reaching goal
                        #Check if this progress will reach the goal
                        - if <[player].flag[nara_quest].get[2].add[1]> >= <server.flag[nara_daily].get[3]>:
                            - flag <[player]> nara_quest:<list[<[player].flag[nara_quest].get[1]>|<[player].flag[nara_quest].get[2].add[1]>|complete]>
                            - narrate "<server.flag[pfx_nara]><&6> Your Progress: <&f><[player].flag[nara_quest].get[2]>/<server.flag[nara_daily].get[3]> <&a>(Complete!)" targets:<[player]>
                            - stop

                        - else:
                            - flag <[player]> nara_quest:<list[<[player].flag[nara_quest].get[1]>|<[player].flag[nara_quest].get[2].add[1]>|active]>
                            - narrate "<server.flag[pfx_nara]><&6> Your Progress: <&f><[player].flag[nara_quest].get[2]>/<server.flag[nara_daily].get[3]>" targets:<[player]>


# Helper script sets a new Nara quest
Nara_quest_gen:
    type: task
    debug: false
    script:
    # check if it's been a while since the last quest was assigned in case of irregular restart
    - if <util.time_now.duration_since[<server.flag[nara_timer]>].in_hours> > 23:
        - flag server nara_timer:<util.time_now>
        - random:
            - flag server nara_daily:<list[item|diamond|5]>
            - flag server nara_daily:<list[item|emerald|10]>
            - flag server nara_daily:<list[item|gold_ingot|12]>
            - flag server nara_daily:<list[item|iron_ingot|15]>

            - flag server nara_daily:<list[kill|zombie|15]>
            - flag server nara_daily:<list[kill|skeleton|15]>
            - flag server nara_daily:<list[kill|spider|12]>
            - flag server nara_daily:<list[kill|creeper|10]>
            - flag server nara_daily:<list[kill|phantom|4]>

            - flag server nara_daily:<list[breed|cow|6]>
            - flag server nara_daily:<list[breed|pig|6]>
            - flag server nara_daily:<list[breed|bee|4]>
            - flag server nara_daily:<list[breed|horse|4]>
            - flag server nara_daily:<list[breed|armadillo|4]>
            - flag server nara_daily:<list[breed|parrot|4]>

        # FORMAT NOTE: the format for this listag ("nara_daily") goes: nara_daily:<list["QUESTTYPE"|"OBJECT"|"QUANTITY"]>

# Helper script to help debug the player interaction - reset flag nara_daily
Nara_debug:
    type: task
    debug: false
    script:
        - if <player.has_flag[nara_daily]>:
            - flag <player> nara_daily:!
            - narrate "[!] Flag nara_daily has been reset!"
        - else:
            - narrate "[!] There is no flag nara_daily set!"

# Helper script to help debug the player interaction - quest gets regenerated. nara_timer doesn't change to not interfere with normal regenerationcycles.
Nara_debug_reroll:
    type: task
    debug: false
    script:
        - flag server nara_daily:!
        - random:
            - flag server nara_daily:<list[item|diamond|5]>
            - flag server nara_daily:<list[item|emerald|10]>
            - flag server nara_daily:<list[item|gold_ingot|12]>
            - flag server nara_daily:<list[item|iron_ingot|15]>

            - flag server nara_daily:<list[kill|zombie|15]>
            - flag server nara_daily:<list[kill|skeleton|15]>
            - flag server nara_daily:<list[kill|spider|12]>
            - flag server nara_daily:<list[kill|creeper|10]>
            - flag server nara_daily:<list[kill|phantom|4]>

            - flag server nara_daily:<list[breed|cow|6]>
            - flag server nara_daily:<list[breed|pig|6]>
            - flag server nara_daily:<list[breed|bee|4]>
            - flag server nara_daily:<list[breed|horse|4]>
            - flag server nara_daily:<list[breed|armadillo|4]>
            - flag server nara_daily:<list[breed|parrot|4]>
        - narrate "[!] New quest has been generated!"