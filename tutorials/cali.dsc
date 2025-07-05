#Cali is the NPC at spawn who greets players and offers tutorials.

## Flags used in this file:
# <server.flag[pfx_cali]> is an elementTag - used as the prefix for this npc's messages
# <player.flag[npc_chatted]> is a boolean - used as a cooldown for entering a seperate zap state

# <player.flag[cali_first_join]> is a boolean - used to limit free keys only to the first tutorial run
# <player.flag[cali_crates_question]> is a boolean - used to limit free keys only to new players
# <player.flag[cali_rewards]> is a boolean - used to limit free rewards only to the first tutorial run

# <player.flag[tutorial_bulki_quest]> is a boolean - used to coordinate with bulki NPC

cali:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:chat state:true cooldown:false radius:5
        - trigger name:click state:true
    interact scripts:
    - cali_main

cali_main:
    type: interact
    debug: false
    steps:

        ## npc intro, offer the tutorial on proximety
        1:
            proximity trigger:
                entry:
                    script:
                    - ratelimit <player> 100s
                    # Welcome player if its their first time
                    - if !<player.has_flag[cali_first_join]>:
                        - narrate "<server.flag[pfx_cali]><&f> Hello <player.name>! Welcome to Hollowtree! I'm Cali, your guide! In order to interact with NPCs such as myself, right click them!"
                    - flag <player> cali_first_join

                    # Offer tutorial
                    - narrate "<server.flag[pfx_cali]><&f> I see you haven't completed the tutorial yet. Would you like to? Rewards are in order if you do!"
                    - narrate <&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Start Tutorial<&7>]].on_click[/denizenclickable chat Start Tutorial]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>Skip Tutorial<&7>]].on_click[/denizenclickable chat Skip Tutorial]><&end_hover>

            click trigger:
                script:
                    - ratelimit <player> 5s
                    # Offer tutorial
                    - narrate "<server.flag[pfx_cali]><&f> I see you haven't completed the tutorial yet. Would you like to? Rewards are in order if you do!"
                    - narrate <&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Start Tutorial<&7>]].on_click[/denizenclickable chat Start Tutorial]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>Skip Tutorial<&7>]].on_click[/denizenclickable chat Skip Tutorial]><&end_hover>

            chat trigger:
                # player starts tutorial
                1:
                    trigger: /Start Tutorial/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> Okay, let's begin the tutorial! Click me for the next step!"
                    - zap 2

                # player skips tutorial
                2:
                    trigger: /Skip Tutorial/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> Okay, come find me if you have any questions!"
                    - zap 12

        ## Discovery lounge question
        # prompt to find
        2:
            click trigger:
                script:
                - ratelimit <player> 15s
                - narrate "<server.flag[pfx_cali]><&f> Getting to know your way around spawn is essential for you to find helpful information."
                - wait 3s
                - narrate "<server.flag[pfx_cali]><&f> The best hub for information is the <&9>Discovery Lounge<&f>! It's right across the square!"
                - wait 3s
                - narrate "<server.flag[pfx_cali]><&f> Explore the <&9>Discovery Lounge<&f> and return here once you have finished."
                - zap 3

        # question upon returning
        3:
            click trigger:
                script:
                - ratelimit <player> 15s
                - narrate "<server.flag[pfx_cali]><&f> A test for you, <player.name>. At what rank can a Trailblazer take to the sky?"
                - wait 1s
                - narrate <&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Watchmaker<&7>]].on_click[/denizenclickable chat Watchmaker]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>Timekeeper<&7>]].on_click[/denizenclickable chat Timekeeper]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>Inventor<&7>]].on_click[/denizenclickable chat Inventor]><&end_hover>

            chat trigger:
                1:
                    trigger: /time|keeper/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> Correct! Well done, <player.name>!"
                    - zap 4

                2:
                    trigger: /watch|maker|invent/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> Perhaps it is best for you to get acquainted with the ranks in the <&9>Discovery Lounge<&f>."

                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> What's that?"

        ## Crates
        # prompt to find, give key if it is the player's first time
        4:
            click trigger:
                script:
                - ratelimit <player> 15s
                - narrate "<server.flag[pfx_cali]><&f> <&b>Atlas Crates & Co. <&f>is a great way for you to gear up with powerful tools!"
                - wait 3s

                - if !<player.has_flag[crates_question]>:
                    - execute as_server 'crates giveKey equipinator <player.name> 1'
                    - narrate "<server.flag[pfx_cali]><&f> Here, a Spark Plug on us to be given to EquiPINator for some tools and gear!"
                - flag player cali_crates_question

                - narrate "<server.flag[pfx_cali]><&f> Take a look around! It's right by the <&9>Discovery Lounge"

                - zap 5

        ## Daily Chest / Crates
        # prompt to find, give key if it is the player's first time
        5:
            click trigger:
                script:
                - ratelimit <player> 15s
                - narrate "<server.flag[pfx_cali]><&f> Our Trailblazers come across all sorts of loot on their expeditions. Sometimes, they share their treasures! Where would I find this Daily Loot?"
                - narrate <&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Brass Cog & Tankard<&7>]].on_click[/denizenclickable chat Brass Cog & Tankard]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>Grand Archives<&7>]].on_click[/denizenclickable chat Grand Archives]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>Outside Atlas Crates & co.<&7>]].on_click[/denizenclickable chat Atlas Crates & co.]><&end_hover>

            chat trigger:
                1:
                    trigger: /atlas|crates/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> Correct! Well done, <player.name>!"
                    - zap 6
                2:
                    trigger: /brass|cog|tank|grand|archives/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> It may be helpful to check <&9>Bulki's workstation<&f>. I hear that Trailblazers leave their treasures near him!"
                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> What's that?"

        ## Common Commands, Set a home
        # give the player a book / display a sidebar(?)
        6:
            click trigger:
                script:
                - ratelimit <player> 15s
                - narrate "<server.flag[pfx_cali]><&f> <player.name>, exploration is not easy. Setting up a camp will become very beneficial when you are out in the wilds!"
                - wait 3s
                - narrate "<server.flag[pfx_cali]><&f> Take this book. It contains valuable information. Return here once you have set a home!"
                # side bar for commands for this step
                # /wild - “Teleport to a random location in the vast wilderness and uncover hidden treasures, breathtaking landscapes, or uncharted territories!”
                # /sethome - “Secure your favorite spot with ease and mark the location youre at as your personal retreat!”
                # /home - “Instantly teleport back to the location you've marked as your home, no matter where your journey takes you.”
                # /spawn - "Travel back to the heart of the isles by teleporting back to [Tutorial NPC]!."
                - zap 7

        # Check to see if a player has set a home
        7:
            click trigger:
                script:
                - ratelimit <player> 15s
                - if <placeholder[cmi_user_homeamount]> >= 1:
                    - narrate "<server.flag[pfx_bulki]><&f> You’ve found yourself a nice camping spot, eh? Well done, onto the next topic!"
                    - zap 8
                - else:
                    - narrate "<server.flag[pfx_bulki]><&f> It would be best to <&9>set a home<&f>. You don’t want to get lost at night, after all!"

        ## Bulki / Scrapper Quest
        # Find Bulki, zap to step in Bulki's script
        8:
            click trigger:
                script:
                - ratelimit <player> 15s
                - narrate "<server.flag[pfx_cali]><&f> Jobs are crucial to conintue the March of Progress.<&6> Speak to Bulki<&f>! He can guide you through obtaining a job."
                - flag player tutorial_bulki_quest
                - zap 2 bulki_main

        ## PVP island question
        # Find the statute on PVP island
        9:
            click trigger:
                script:
                - ratelimit <player> 15s
                - flag player tutorial_bulki_quest:!
                - narrate "<server.flag[pfx_cali]><&f> There are many islands that the March of Progress is stationed at."
                - wait 3s
                - narrate "<server.flag[pfx_cali]><&f> To get there, you should try speaking with <&6>Calypso<&f>, <&6>Astra<&f>, and <&6>Ender<&f>."
                - wait 3s
                - narrate "<server.flag[pfx_cali]><&f> Keep an eye out for the <&9>Statue of Auriel<&f>!"
                - zap 10

        # Question for the PVP island
        10:
            click trigger:
                script:
                - ratelimit <player> 15s
                - narrate "<server.flag[pfx_cali]><&f> This Realm houses many celestials and deities, but none are more important than Auriel. Can you find where Auriel’s statue resides?"
                - narrate <&7><&o><&sp>→<&sp>Respond<&sp>with<&sp><&hover[<&7>click to respond]><element[[<&e>Shatterpoint Spire<&7>]].on_click[/denizenclickable chat Shatterpoint Spire]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>Stellar Gateway Isle<&7>]].on_click[/denizenclickable chat Stellar Gateway Isle]><&end_hover><&sp><&hover[<&7>click to respond]><element[[<&e>Windspire Cove<&7>]].on_click[/denizenclickable chat Windspire Cove]><&end_hover>

            chat trigger:
                1:
                    trigger: /shatter|point|spire/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> Correct! Shatterpoint Spire is where the Statue of Auriel resides, watching over all of us!"
                    - zap 11

                2:
                    trigger: /stellar|gateway|isle|wind|spire|cove/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> It would be worthwhile speaking to <&9>Ender<&f>, <player.name>."

                3:
                    trigger: /*/
                    hide trigger message: true
                    show as normal chat: false
                    script:
                    - narrate "<server.flag[pfx_cali]><&f> What's that?"

        ## Tutorial completion handler
        # Tutorial completion, mete rewards
        11:
            click trigger:
                script:
                - ratelimit <player> 15s
                - narrate "<server.flag[pfx_cali]><&f> You have successfull completed the tutorial! Please enjoy your rewards!"
                - wait 3s
                - narrate "<server.flag[pfx_cali]><&f> Come find me if you have any questions!"

                ## give rewards here
                #- if !<player.has_flag[cali_rewards]>:
                #    - narrate hello
                #- flag player cali_rewards

                - execute as_server 'money give <player.name> 3 Sigils'
                - execute as_server 'acb <player.name> 200'

        # Primary zap step, prompts player with the deluxemenu
        12:
            click trigger:
                script:
                - execute as_server "dm open guides_menu <player.name>"