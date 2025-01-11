# use in-game to remove the flag from you
# /ex flag <player> rankinformation:true expire:1
rankinformation_tutorial:
  type: task
  definitions: player_name
  script:

# introductory dialogue to ranks

  - define player_obj <server.match_player[<[player_name]>]>
  - define flag_name rankinformation
  - narrate "<server.has_flag[pfx_tutorial]> This tutorial will inform you on our Ranks System." target:<[player_obj]>
  - wait 5
  - narrate "<server.has_flag[pfx_tutorial]> Every individual starts out as a #Skyrat# - think of it as the foundation of your potential." target:<[player_obj]>
  - wait 5
  - narrate "<server.has_flag[pfx_tutorial]> From here, you’ll climb the ranks by achieving <&6>specific goals<&f>, <&6>mastering challenges<&f>, and <&6>earning recognition<&f>." target:<[player_obj]>
  - wait 5
  - narrate "<server.has_flag[pfx_tutorial]> As you rank up, you’ll unlock new privileges, responsibilities, and rewards that reflect your status and achievements." target:<[player_obj]>
  - wait 5
  - narrate "<server.has_flag[pfx_tutorial]> Each rank represents more than just a title. It’s proof of your hard work, your mastery, and your contribution to the community." target:<[player_obj]>
  - wait 5
  - narrate "<server.has_flag[pfx_tutorial]> But don’t worry - it’s not a race. Everyone progresses at their own pace." target:<[player_obj]>
  - wait 5
  - narrate "<server.has_flag[pfx_tutorial]> To rank up, use the command: <&6>/trust (player)<&f>." target:<[player_obj]>
  - wait 5
  - narrate "<server.has_flag[pfx_tutorial]> If you do not meet the requirements, you will be informed of the tasks and challenges you need to complete prior to ranking up." target:<[player_obj]>
  - wait 5
  - narrate "<server.has_flag[pfx_tutorial]> The <&9>Discovery Lounge <&f>houses important information, of which includes the numver of ranks and some of their privileges!" target:<[player_obj]>
  - wait 5

  - narrate "<server.has_flag[pfx_tutorial]> A test for you, <player.name>. At what rank can a <&5>Trailblazer take to the sky<&f>?" target:<[player_obj]>
  - wait 2

  - if !<[player_obj].has_flag[<[flag_name]>]>:
      - flag <[player_obj]> <[flag_name]>:true
      - execute as_server "money give <[player_obj].name> 500"
      - narrate "<server.has_flag[pfx_tutorial]> You've received <&a>500 Coins<&f> for completing this pfx_tutorial." target:<[player_obj]>