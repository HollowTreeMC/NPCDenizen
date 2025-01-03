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
            - execute as_server "dm open xurshop_menu <player.name>"
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
            - flag server xur_location:<location[-70.5,154,2.5,0,0,Void]>
            - flag server xur_location:<location[-81.5,148,-40.5,0,0,Void]>
            - flag server xur_location:<location[11.5,155,-93.5,0,0,Void]>
            - flag server xur_location:<location[86.5,142,-47.5,0,0,Void]>
            - flag server xur_location:<location[54.5,130.0,42.5,0,0,Void]>

        # select the items for this week's shop
        - run xur_tier1 def:xur_shop_slot1
        - run xur_tier1 def:xur_shop_slot2
        - run xur_tier2 def:xur_shop_slot3
        - run xur_tier2 def:xur_shop_slot4
        - run xur_tier2 def:xur_shop_slot5

    # teleports xur to the correct location
    - teleport <npc[28]> <server.flag[xur_location]>

xur_tier1:
    type: task
    definitions: slot_flag
    script:
    - random:
        - flag server <[slot_flag]>:<server.flag[xur_shop_doombringer]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_arachnids]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_divine]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_earthsrich]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_earthmover]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_midas]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_silkstrike]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_splintered]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_silked]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_wings]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_shadowstrike]>
        - flag server <[slot_flag]>:<server.flag[xur_shop_abyssal]>

xur_tier2:
    type: task
    definitions: slot_flag
    script:
    - random:
        - flag server <[slot_flag]>:<server.flag[gearlord_smiter]>
        - flag server <[slot_flag]>:<server.flag[gearlord_edge]>
        - flag server <[slot_flag]>:<server.flag[gearlord_carver]>
        - flag server <[slot_flag]>:<server.flag[gearlord_silkenspade]>
        - flag server <[slot_flag]>:<server.flag[gearlord_channeler]>
        - flag server <[slot_flag]>:<server.flag[gearlord_flintlock]>
        - flag server <[slot_flag]>:<server.flag[gearlord_impact]>
        - flag server <[slot_flag]>:<server.flag[gearlord_spitfire]>
        - flag server <[slot_flag]>:<server.flag[gearlord_glimmer]>
        - flag server <[slot_flag]>:<server.flag[gearlord_pike]>
        - flag server <[slot_flag]>:<server.flag[gearlord_fortune_seeker]>
        - flag server <[slot_flag]>:<server.flag[gearlord_tinker]>
        - flag server <[slot_flag]>:<server.flag[gearlord_handaxe]>
        - flag server <[slot_flag]>:<server.flag[gearlord_hatchet]>
        - flag server <[slot_flag]>:<server.flag[gearlord_fractal_drill]>
        - flag server <[slot_flag]>:<server.flag[gearlord_harvester]>
        - flag server <[slot_flag]>:<server.flag[gearlord_sparkle]>
        - flag server <[slot_flag]>:<server.flag[gearlord_cultivator]>
        - flag server <[slot_flag]>:<server.flag[gearlord_hood]>
        - flag server <[slot_flag]>:<server.flag[gearlord_plating]>
        - flag server <[slot_flag]>:<server.flag[gearlord_embrace]>
        - flag server <[slot_flag]>:<server.flag[gearlord_ice_treads]>
        - flag server <[slot_flag]>:<server.flag[gearlord_water_treads]>
        - flag server <[slot_flag]>:<server.flag[gearlord_jetpack]>
        - flag server <[slot_flag]>:<server.flag[platypus]>