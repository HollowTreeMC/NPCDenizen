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

        # main runtime
        2:
            click trigger:
                script:
                - cooldown 6s
                # is the shop active?
                - if !<server.has_flag[xur_quest]>:
                    # shop is inactive, return dialouge:
                    - if <util.random_chance[1]>:
                        - narrate "<server.flag[pfx_xur]><&f> Wait, why am I blocky?"
                    - else:
                        - random:
                            - narrate "<server.flag[pfx_xur]><&f> My function here is to trade. I know this."
                            - narrate "<server.flag[pfx_xur]><&f> I am filled with secrets, but you would not understand them."
                            - narrate "<server.flag[pfx_xur]><&f> May we speak?"
                            - narrate "<server.flag[pfx_xur]><&f> There is no reason to fear me."
                            - narrate "<server.flag[pfx_xur]><&f> Do not be alarmed, I have no reason to cause you harm."

                - else:
                    # shop is active, did the player complete the quest?
                    - if !<player.has_flag[xur_quest]>:
                        # quest incomplete, maybe they completed it now?
                        - if <player.inventory.contains_item[<server.flag[xur_quest].get[1]>]>:
                            # player has completed the quest!
                            - narrate "<server.flag[pfx_xur]><&f> <server.flag[xur_quest].get[3]>"
                            - take item:<server.flag[xur_quest].get[1]>
                            - flag <player> xur_quest expire:3d
                        - else:
                            # player has not completed the quest...
                            - narrate "<server.flag[pfx_xur]><&f> <player.name>, <server.flag[xur_quest].get[2]>"
                            - wait 3
                            - narrate "<server.flag[pfx_xur]><&f> Bring it to me, and I will exchange it for something far more elusive..."

                    # quest complete
                    - else:
                        # did the player already buy from the shop?
                        - if <player.has_flag[xur_obtained]>:
                            - narrate "<server.flag[pfx_xur]><&f> I have no more wares for you..."
                        # here's the shop menu player.name!
                        - else:
                            - if <player.has_flag[xur_quest]>:
                                - narrate "<server.flag[pfx_xur]><&f> My wares... Choose wisely..."
                                - wait 2
                                - execute as_server "dm open xurshop_menu <player.name>"

# Configures Xur
xur_shop:
    type: task
    script:

    # Monday Reset
    - if <util.time_now.day_of_week> == 1:
        # Spawn - Behind Admin Shop
        - flag server xur_location:<location[83.5,150,-11.8,-5,-64,Void]>

    # Saturday Configuration
    - if <util.time_now.day_of_week> == 6:
        # Oi! has Xur has already been configured?
        - if !<server.has_flag[xur_quest]>:

            # select the quest for the week
            - random:
                - flag server xur_quest:<list[beacon|"that which shines..."|"Ah... it shines so brightly..."]> expire:2d
                - flag server xur_quest:<list[golden_apple|"perhaps you possess this delicacy... there is power in that fruit..."|"This fruits power is fleeting..."]> expire:2d
                - flag server xur_quest:<list[diamond_horse_armor|"the gleam, the shine, the promise of premier protection for your steed — such a magnificent treasure I seek..."|"Ahhh, how it glitters, how it protects..."]> expire:2d
                - flag server xur_quest:<list[recovery_compass|"I seek a device designed to guide the lost, the wounded... the weary... The compass I seek is no normal compass..."|"Recovery has a price..."]> expire:2d
                - flag server xur_quest:<list[end_crystal|"this crystal you must bring me, it calls to the darkness. It has the power to summon a great dragon..."|"Unimagineable power..."]> expire:2d
                # the format for this listag goes: xur_quest:<list[ITEM]||"item hint"|"Upon quest completion"> expire:2d

            # select the items for this week's shop
            - run xur_tier1 def:xur_shop_slot1
            - run xur_tier1 def:xur_shop_slot2
            - run xur_tier2 def:xur_shop_slot3
            - run xur_tier2 def:xur_shop_slot4
            - run xur_tier2 def:xur_shop_slot5

            # set the location for this week's shop
            - random:
                # Spawn - Next to Crates
                - flag server xur_location:<location[-70.5,154,2.5,0,0,Void]>
                # Spawn - Cave Side
                - flag server xur_location:<location[-81.5,148,-40.5,0,0,Void]>
                # Main Island Explorer Warp area - In the room attachec to the side of the island
                - flag server xur_location:<location[11.5,155,-93.5,0,0,Void]>
                # Spawn - Under Hollowtree tree
                - flag server xur_location:<location[86.5,142,-47.5,0,0,Void]>
                # Spawn - Next to waterfall
                - flag server xur_location:<location[54.5,130.0,42.5,0,0,Void]>
                # Explorer Island - Under the large decorative house in the back of the island
                - flag server xur_location:<location[-1033.5,170.0,111.5,0,0,Void]>
                # Portal Island - On the resource world teleport island
                - flag server xur_location:<location[-1903.5,38.0,1066.5,0,0,Void]>

                # REMOVE OLD LOCATIONS AND ADD THESE ON FULL RELEASE OF 1.21.X

                # Portal Island - Down the flowing water into a hidden room
                # - flag server xur_location:<location[1941.5,29.0,1058.5,0,0,Void]>
                # Portal Island - Inside large cooling tube next to end portal
                # - flag server xur_location:<location[2066.5,47.0,1035.5,0,0,Void]>
                # Spawn Island - Climb up the big tree at the back of the island
                # - flag server xur_location:<location[67.5,169.0,-23.5,0,0,Void]>
                # Spawn Island - Secret room behind Discovery Lounge
                # - flag server xur_location:<location[-64.5,139.0,-24.5,0,0,Void]>
                # PvP Island - Inside green airship
                # - flag server xur_location:<location[1737.5,90.0,134.5,0,0,Void]>
                # PvP Island - Inside copper chimney
                # - flag server xur_location:<location[1688.5,96.0,198.5,0,0,Void]>
                # Explorer Island - Side of the main island
                # - flag server xur_location:<location[-983.5,178.0,95.5,0,0,Void]>
                # Explorer Island - Inside yellow balloon
                # - flag server xur_location:<location[-982.5,217.0,76.5,0,0,Void]>


        # teleports xur to the correct location
        - teleport <npc[28]> <server.flag[xur_location]>

# Contains all the black market items
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

# Contains Tier 3 crate gear
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