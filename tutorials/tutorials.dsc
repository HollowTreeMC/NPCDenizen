# use in-game to remove the flag from you
# /ex flag <player> griefprevention:true expire:1
griefprevention_tutorial:
  type: task
  definitions: player_name
  script:
  - define player_obj <server.match_player[<[player_name]>]>
  - define prefix "<&7>[<&e>Tutorial<&7>]<&f>"
  - define flag_name griefprevention
  - narrate "<[prefix]> Welcome to the GriefPrevention claiming tutorial!" target:<[player_obj]>
  - wait 4
  - narrate "<[prefix]> GriefPrevention lets you protect your builds and land from other players." target:<[player_obj]>
  - wait 4
  - narrate "<[prefix]> To get started, you'll need a golden shovel. You can type <&6>/kit claim<&f> to get one." target:<[player_obj]>
  - wait 4
  - narrate "<[prefix]> Once you have the shovel, right-click two corners of the area you'd like to claim." target:<[player_obj]>
  - wait 6
  - narrate "<[prefix]> You’ll see glowstone and gold blocks outlining your claim temporarily." target:<[player_obj]>
  - narrate "Claims cost claim blocks, which you earn while playing." target:<[player_obj]>
  - wait 6
  - narrate "<[prefix]> To resize your claim, use the golden shovel and right-click one of the corners." target:<[player_obj]>
  - wait 4
  - narrate "<[prefix]> To trust someone in your claim, use the command: <&6>/trust (player)<&f>." target:<[player_obj]>
  - wait 4
  - narrate "<[prefix]> To untrust someone, use: <&6>/untrust (player)<&f>." target:<[player_obj]>
  - wait 4
  - narrate "<[prefix]> You can abandon a claim if you no longer need it with: <&6>/abandonclaim<&f>." target:<[player_obj]>
  - wait 4
  - narrate "<[prefix]> That's it! Type <&6>/claimslist<&f> to see all your claims." target:<[player_obj]>
  - narrate "If you need more help, type <&6>/help GriefPrevention<&f> or ask an admin!" target:<[player_obj]>
  - wait 4
  - narrate "<[prefix]> Happy claiming! If you need a refresher, you can run the tutorial again!" target:<[player_obj]>
  - if !<[player_obj].has_flag[<[flag_name]>]>:
      - flag <[player_obj]> <[flag_name]>:true
      - execute as_server "money give <[player_obj].name> 500"
      - narrate "<[prefix]> You've received <&a>500 Coins<&f> for completing this tutorial." target:<[player_obj]>