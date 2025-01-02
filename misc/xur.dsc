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
        #gives flag with 3 day expiry upon quest completion
        - if <player.inventory.contains_item[beacon]>:
            - narrate "<server.flag[pfx_xur]><&f> it shines so brightly..."
            - flag <player> xur_quest expire:3d
        - else:
            - narrate "<server.flag[pfx_xur]><&f> <player.name> bring me a beacon..."

# configures the xur shop, meant only to run once a week
xur_shop:
    type: task
    script:
    # Monday Reset
    - if <util.time_now.day_of_week> == 1:
        - flag server xur_location:<location[83.5,150,-11.8,-5,-64,Void]>

    # Friday Configuration
    - if <util.time_now.day_of_week> == 5:
        - random:
            - flag server xur_location:<location[-70.5,154,2.5,0,0,Void ]>
            - flag server xur_location:<location[-81.5,148,-40.5,0,0,Void ]>
            - flag server xur_location:<location[11.5,155,-93.5,0,0,Void ]>
            - flag server xur_location:<location[86.5,142,-47.5,0,0,Void ]>
            - flag server xur_location:<location[54.5,130.0,42.5,0,0,Void ]>

        # select the items for this week's shop, rarity of item decreases a -> e
        - random:
            - flag server xur_shop_a:<server.flag[xur_shop_x1]>
            - flag server xur_shop_a:<server.flag[xur_shop_x2]>
            - flag server xur_shop_a:<server.flag[xur_shop_x3]>
            - flag server xur_shop_a:<server.flag[xur_shop_x4]>
            - flag server xur_shop_a:<server.flag[xur_shop_x5]>

        - random:
            - flag server xur_shop_b:<server.flag[xur_shop_b1]>
            - flag server xur_shop_b:<server.flag[xur_shop_b2]>
            - flag server xur_shop_b:<server.flag[xur_shop_b3]>
            - flag server xur_shop_b:<server.flag[xur_shop_b4]>
            - flag server xur_shop_b:<server.flag[xur_shop_b5]>

        - random:
            - flag server xur_shop_c:<server.flag[xur_shop_c1]>
            - flag server xur_shop_c:<server.flag[xur_shop_c2]>
            - flag server xur_shop_c:<server.flag[xur_shop_c3]>
            - flag server xur_shop_c:<server.flag[xur_shop_c4]>
            - flag server xur_shop_c:<server.flag[xur_shop_c5]>

        - random:
            - flag server xur_shop_d:<server.flag[xur_shop_d1]>
            - flag server xur_shop_d:<server.flag[xur_shop_d2]>
            - flag server xur_shop_d:<server.flag[xur_shop_d3]>
            - flag server xur_shop_d:<server.flag[xur_shop_d4]>
            - flag server xur_shop_d:<server.flag[xur_shop_d5]>

        - random:
            - flag server xur_shop_e:<server.flag[xur_shop_e1]>
            - flag server xur_shop_e:<server.flag[xur_shop_e2]>
            - flag server xur_shop_e:<server.flag[xur_shop_e3]>
            - flag server xur_shop_e:<server.flag[xur_shop_e4]>
            - flag server xur_shop_e:<server.flag[xur_shop_e5]>

    # teleports xur to the correct location
    - teleport <npc[28]> <server.flag[xur_location]>