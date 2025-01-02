# this script is for the black market npc who teleports around depending on the day
xur:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - Xur_main

xur_main:
    type: interact
    steps:
        # introductory script
        1:
            click trigger:
                script:
                - narrate "<server.flag[pfx_xur]><&f> Hmm..."
                - zap 2

        # check the day, call the relevant script based on the day
        2:
            click trigger:
                script:
                - cooldown 10s
                - if <util.time_now.day_of_week> < 5:
                    - run xur_weekday
                - else:
                    - run xur_weekend

# respond with dialouge on weekdays
xur_weekday:
    type: task
    script:
    - if <util.random_chance[1]>:
        - narrate "<server.flag[pfx_xur]><&f> Wait, why am I blocky?"
    - else:
        - random:
            - narrate "<server.flag[pfx_xur]><&f> My function here is to trade. I know this."
            - narrate "<server.flag[pfx_xur]><&f> I am filled with secrets, but you would not understand them."
            - narrate "<server.flag[pfx_xur]><&f> May we speak?"
            - narrate "<server.flag[pfx_xur]><&f> There is no reason to fear me."
            - narrate "<server.flag[pfx_xur]><&f> Do not be alarmed, I have no reason to cause you harm."

# give a quest, open the DM when quest is complete
xur_weekend:
    type: task
    script:
    #check to see if player has the xur flag
    - if <player.has_flag[xur_quest]>:
        - narrate "open the shop DM"
    #prompts the player with a quest
    - else:
        - narrate "<server.flag[pfx_xur]><&f> Here's your quest"
        #gives flag with 3 day expiry upon quest completion

# configures the xur shop, meant only to run once a week
xur_shop:
    type: task
    script:
    - narrate "<server.flag[pfx_xur]><&f> Configured the shop"