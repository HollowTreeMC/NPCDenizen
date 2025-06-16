# This file contains the the scripts for the Dragon Slayer event on HollowTree

## Flags used in this file:
# <server.flag[eventTag]> is a string element - used as the prefix for event messages
# <server.flag[dragonEvent]> is a BOOLEAN - used to indicate whether the event is ongoing
# <server.flag[dragonEventPoints]> is a maptag - keys are players.uuid and values are points

# <entity.flag[attackingPlayers]> is a mapTag - keys are player.uuid and values are damage dealt

Dragon_Slayer:
  type: world
  debug: true
  events:

    # Listens for players damaging the ender dragon
    on player damages ender_dragon:

    # check to see if the event is enabled
    - if <server.has_flag[dragonEvent]>:

      # if this is the first time the dragon has been attacked, announce to all players
      - if !<context.entity.has_flag[attackingPlayers]>:
        - foreach <server.online_players>:
          - narrate "<server.flag[eventTag]> <&r>A <&d>Dragon Fight <&f>has started! Head to the <server.flag[loc_StellarGallery]> and get points by attacking the dragon!"

      # add player's damage to the current entity, attackingplayers is a map containing playerUUID=damage
      - define atkPlayersMap:<context.entity.flag[attackingPlayers]>
      - if <[atkPlayersMap].contains[<player.uuid>]>:
        # player is already on the list, increase their damage
        - define totalDMG:<[atkPlayersMap].get[<player.uuid>].add[<context.damage>]>
        - flag <context.entity> attackingPlayers:<[atkPlayersMap].with[<player.uuid>].as[<[totalDMG]>]>
      - else:
        # player is not on the list, add them to the list
        - flag <context.entity> attackingPlayers:<[atkPlayersMap].include[<player.uuid>=<context.damage>]>
        - narrate "<server.flag[eventTag]> <&r>You've entered the <&d>Dragon Fight<&f>! Kill the dragon to get points toward the event!"

    # Listens for dragons being killed by players
    on player kills ender_dragon:

    # check to see if the event is enabled
    - if <server.has_flag[dragonEvent]>:

      # store the entity's damage map tag
      - define atkPlayersMap:<context.entity.flag[attackingPlayers]>

      # give the slayer 2 points
      - define slayerPoints:<server.flag[dragonEventPoints].get[<player.uuid>].if_null[0].add[2]>
      - flag server dragonEventPoints:<server.flag[dragonEventPoints].with[<player.uuid>].as[<[slayerPoints]>]>
      - narrate "<server.flag[eventTag]> <reset>You slayed the <&d>Dragon<&f>! <&7><&o>+2 points" targets:<player>

      # sort the player damage to dragon map (dict)
      - define sorted_atkPlayersMap:<context.entity.flag[attackingPlayers].sort_by_value[mul[-1]]>
      - foreach <[sorted_atkPlayersMap].keys> as:key:

        # give the highest damager 2 points
        - if <[loop_index]> == 1:
          - define damagerPoints:<server.flag[dragonEventPoints].get[<[key]>].if_null[0].add[2]>
          - flag server dragonEventPoints:<server.flag[dragonEventPoints].with[<[key]>].as[<[damagerPoints]>]>
          - narrate "<server.flag[eventTag]> <reset>You dealt the most damage to the <&d>Dragon<&f>! <&7><&o>+2 points" targets:<player[p@<[key]>]>

        # give each participant 3 points
        - define participantPoints:<server.flag[dragonEventPoints].get[<[key]>].if_null[0].add[2]>
        - flag server dragonEventPoints:<server.flag[dragonEventPoints].with[<[key]>].as[<[participantPoints]>]>
        - narrate "<server.flag[eventTag]> <reset>You helped slay the <&d>Dragon<&f>! <&7><&o>+3 points" targets:<player[p@<[key]>]>

      # let all players know a dragon has been defeated
      ## add clickable to view leaderboard in this message
      - narrate "<server.flag[eventTag]> <reset>A <&d>Dragon<&f> was defeated by <player.name>" target:<server.online_players>
      # display the leaderboard for all players for 30 seconds
      - foreach <server.online_players> as:players:
        - run dragonleaderboard def:<[players]>

DragonLeaderboard:
  type: task
  debug: true
  definitions: players
  script:
    # sort the server leaderboard maptag
    - define sorted_PointsMap:<server.flag[dragonEventPoints].sort_by_value[mul[-1]]>
    # populate places 1 to 5
    - foreach <[sorted_PointsMap].keys> as:key:
      - if <[loop_index]> < 6:
        - define values:->:'<&6><[loop_index]>:<&sp><&e><player[p@<[key]>].name>'
        - define scores:->:<server.flag[dragonEventPoints].get[<[key]>]>
      # obtain the player's place
      - if key == <[players].uuid>:
        - define personalPlace:<[loop_index]>
    # add a space to make the personal place a footer
    - define values:->:'<&sp>'
    - define scores:->:'<&sp>'
    # populate player's place
    - define values:->:'<&6><[personalPlace]>:<&sp><&e><[player].name>'
    - define scores:->:<server.flag[dragonEventPoints].get[<[players].uuid>]>
    # display the sidebar for the player
    - define title:<&d>Dragon<&sp>Hunters<&sp>Leaderboard
    - sidebar set title:<[title]> values:<[values]> scores:<[scores]> players:<[players]>
    - wait 30s
    - sidebar remove players:<[players]>

#Start, Stop, reset, sidebar, and count cmds
dragonEventCmd:
  type: command
  debug: true
  description: Dragon Slayer Event Commands
  name: dragon
  usage: /dragon [command]
  tab completions:
    1: count|sidebar|score|<player.has_permission[event.toggle].if_true[restart|stop|continue].if_false[]>
  script:
  - choose <context.args.first>:
    - case stop:
        - if <player.has_permission[event.toggle]>:
          - narrate "<server.flag[eventTag]> You have stopped the event! Event will not be tracked, no points will be reset. <&nl>This is for debugging! Use /hollowevent start to reset all totals! <&nl><&6>To continue the current event, use /HollowEvent continue!"
          - flag server dragonEvent:!
    - case pause:
      - if <player.has_permission[event.toggle]>:
        - narrate "<server.flag[eventTag]> You have stopped the event! Event will not be tracked. <&nl><&6>To continue the current event, use /HollowEvent continue!"
        - flag server dragonEvent:!



      - case reset:
        - if <player.has_permission[event.toggle.admin]>:
          - narrate "<server.flag[eventTag]> You've reset all the event counters!"
          - flag server ph1:!
          - flag server name1st:!
          - flag server ph2:!
          - flag server name2nd:!
          - flag server ph3:!
          - flag server name3rd:!
          - flag server ph4:!
          - flag server name4th:!
          - flag server ph5:!
          - flag server name5th:!
          - foreach <server.players>:
            - flag <[value]> enderDragonsKilled:!
          - flag server dragonEvent:!
      - case start:
        - if <player.has_permission[event.toggle]> && !<server.has_flag[dragonEvent]>:
          - execute as_server 'cmi broadcast !<&8>---------------------------------------<&nl>{#00ff94>}&lHollow Dragon Hunting{#188377<>} Event Has Begun!&l{#00ff94<} <&nl><&nl><&r>{#188377}<&l>Dragon slayers<reset> will be awarded <dark_green>5<reset> points per kill and <aqua>2<reset> extra points will be awarded to the <bold>highest damager<aqua>!<reset><&nl><&nl>Kill {#00ff94}dragons <reset>to earn your place on the {#00ff94}<&l>Leaderboard<&color[#00e6ca]>! <&nl><&nl>Use command {#00ff94}/HollowEvent sidebar <&color[#00e6ca]>to view the leaderboard and {#00ff94}/HollowEvent count <&color[#00e6ca]>for your totals!<&nl><&a>| <&7><&o>To opt out, use the command /HollowEvent leave!<&a> | <&8>---------------------------------------'
          - flag server dragonEvent
          - flag server ph1:0
          - flag server ph2:0
          - flag server ph3:0
          - flag server ph4:0
          - flag server ph5:0
          - flag server name1st:?
          - flag server name2nd:?
          - flag server name3rd:?
          - flag server name4th:?
          - flag server name5th:?
        - else if <player.has_permission[event.toggle]>:
          - narrate "<server.flag[eventTag]> You attempted to start a new event before resetting the old event! Use /HollowEvent reset before starting a new event!"
      - case continue:
        - if <player.has_permission[event.toggle]>:
          - flag server dragonEvent
          - narrate "<server.flag[eventTag]> You have resumed the current event!"
      - case count:
        - if <server.has_flag[dragonEvent]>:
          - if <player.has_flag[enderDragonsKilled]> && !<player.has_flag[noHollowEvent]>:
            - narrate "<&a><&l>Your current dragon hunting event total:<&nl> <&2>Killed: <&a><player.flag[enderDragonsKilled]>"
          - if <player.has_flag[enderDragonsKilled]> < 1:
            - narrate "<server.flag[eventTag]> You must kill dragons to see your points!"
        - else:
          - narrate "<server.flag[eventTag]> No event is currently active!"
      - case sidebar:
        - if <player.has_flag[sidebarStickOn]>:
          - sidebar remove
          - flag <player> sidebarStickOn:!
          - narrate "<server.flag[eventTag]> Event sidebar disabled! <&nl><&7><&o>/hollowevent sidebar to enable."
          - stop
        - if !<player.has_flag[sidebarStickOn]>:
          - if <server.has_flag[dragonEvent]> && !<player.has_flag[noHollowEvent]>:
            - flag player sidebarStickOn duration:5d
            - run Sidebar_handler_personal def:<player>
            - narrate "<server.flag[eventTag]> Enabling sidebar! <&nl><&7><&o>/hollowevent sidebar to disable."
          - else if !<server.has_flag[dragonEvent]>:
            - narrate "<server.flag[eventTag]> No event is currently active!"
            - sidebar remove
            - flag <player> sidebarStickOn:!
      - case score:
        - if <server.has_flag[dragonEvent]> && !<player.has_flag[noHollowEvent]>:
          - if <player.has_flag[enderDragonsKilled]>:
            - narrate "<&a><&l>Your current dragon hunting event total:<&nl> <&2>Killed: <&a><player.flag[enderDragonsKilled]>"
          - run Sidebar_handler
          - wait 60s
          - sidebar remove
        - else if !<server.has_flag[dragonEvent]>:
          - narrate "<server.flag[eventTag]> No event is currently active!"
        - else if !<player.has_flag[noHollowEvent]>:
          - narrate "<server.flag[eventTag]> The event is not currently active for you! /HollowEvent join to rejoin the hunt!"
      - case leave:
        - if <server.has_flag[dragonEvent]>:
          - flag player noHollowEvent expire:5d
          - narrate "<server.flag[eventTag]> You have opted out of the dragon hunting event! To join back, use the command /HollowEvent join."
      - case join:
        - if <server.has_flag[dragonEvent]>:
          - narrate "<server.flag[eventTag]> You have rejoined the dragon hunting event! Best of luck!"
          - flag player noHollowEvent:!


#Task for sidebar to set it and gives a flag with a cooldown, players with this flag are automatically updated when anyone changes in the top 5 places.
Sidebar_handler:
  type: task
  debug: false
  script:
    - sidebar set "title:<&b><&l>| <&color[#00b37d]><&l>Top Dragon Hunters<&b> <&l>|" "values:<&6>1st: <&e><server.flag[name1st]>|<&6>2nd: <&e><server.flag[name2nd]>|<&6>3rd: <&e><server.flag[name3rd]>|<&6>4th: <&e><server.flag[name4th]>|<&6>5th: <&e><server.flag[name5th]>" scores:<server.flag[ph1]>|<server.flag[ph2]>|<server.flag[ph3]>|<server.flag[ph4]>|<server.flag[ph5]> players:<server.players_flagged[sidebarStick]> per_player
#Task for sidebar to set it and gives a flag with a cooldown, players with this flag are automatically updated when anyone changes in the top 5 places.
Sidebar_handler_personal:
  type: task
  debug: true
  definitions: sidebarEnabler
  script:
    - sidebar set "title:<&b><&l>| <&color[#00b37d]><&l>Top Dragon Hunters<&b> <&l>|" "values:<&6>1st: <&e><server.flag[name1st]>|<&6>2nd: <&e><server.flag[name2nd]>|<&6>3rd: <&e><server.flag[name3rd]>|<&6>4th: <&e><server.flag[name4th]>|<&6>5th: <&e><server.flag[name5th]>" scores:<server.flag[ph1]>|<server.flag[ph2]>|<server.flag[ph3]>|<server.flag[ph4]>|<server.flag[ph5]> players:<[sidebarEnabler]> per_player