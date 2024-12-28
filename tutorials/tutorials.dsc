# use in-game to remove the flag from you
# /ex flag <player> griefprevention:true expire:1
griefprevention_tutorial:
  type: task
  definitions: player_name
  script:
  - define player_obj <server.match_player[<[player_name]>]>
  - define flag_name griefprevention
  - narrate "<server.has_flag[pfx_tutorial]> Welcome to the GriefPrevention claiming pfx_tutorial!" target:<[player_obj]>
  - wait 4
  - narrate "<server.has_flag[pfx_tutorial]> GriefPrevention lets you protect your builds and land from other players." target:<[player_obj]>
  - wait 4
  - narrate "<server.has_flag[pfx_tutorial]> To get started, you'll need a golden shovel. You can type <&6>/kit claim<&f> to get one." target:<[player_obj]>
  - wait 4
  - narrate "<server.has_flag[pfx_tutorial]> Once you have the shovel, right-click two corners of the area you'd like to claim." target:<[player_obj]>
  - wait 6
  - narrate "<server.has_flag[pfx_tutorial]> You’ll see glowstone and gold blocks outlining your claim temporarily." target:<[player_obj]>
  - narrate "Claims cost claim blocks, which you earn while playing." target:<[player_obj]>
  - wait 6
  - narrate "<server.has_flag[pfx_tutorial]> To resize your claim, use the golden shovel and right-click one of the corners." target:<[player_obj]>
  - wait 4
  - narrate "<server.has_flag[pfx_tutorial]> To trust someone in your claim, use the command: <&6>/trust (player)<&f>." target:<[player_obj]>
  - wait 4
  - narrate "<server.has_flag[pfx_tutorial]> To untrust someone, use: <&6>/untrust (player)<&f>." target:<[player_obj]>
  - wait 4
  - narrate "<server.has_flag[pfx_tutorial]> You can abandon a claim if you no longer need it with: <&6>/abandonclaim<&f>." target:<[player_obj]>
  - wait 4
  - narrate "<server.has_flag[pfx_tutorial]> That's it! Type <&6>/claimslist<&f> to see all your claims." target:<[player_obj]>
  - narrate "If you need more help, type <&6>/help GriefPrevention<&f> or ask an admin!" target:<[player_obj]>
  - wait 4
  - narrate "<server.has_flag[pfx_tutorial]> Happy claiming! If you need a refresher, you can run the pfx_tutorial again!" target:<[player_obj]>
  - if !<[player_obj].has_flag[<[flag_name]>]>:
      - flag <[player_obj]> <[flag_name]>:true
      - execute as_server "money give <[player_obj].name> 500"
      - narrate "<server.has_flag[pfx_tutorial]> You've received <&a>500 Coins<&f> for completing this pfx_tutorial." target:<[player_obj]>