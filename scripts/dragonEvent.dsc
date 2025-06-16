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
    # Listens for an ender dragon spawning
    on ender_dragon spawns because default:
    - if <server.has_flag[dragonEvent]>:
      - narrate "<server.flag[eventTag]> <&r>A <&d>Dragon Fight <&f>has started! Head to the <server.flag[loc_StellarGallery]> and get points by attacking the dragon!" targets:<server.online_players>
      - flag <context.entity> attackingPlayers:<map[]>

    # Listens for players damaging the ender dragon
    on player damages ender_dragon:
    # check to see if the event is enabled
    - if <server.has_flag[dragonEvent]>:

      # add player's damage to the current entity, attackingplayers is a map containing playerUUID=damage
      - define atkPlayersMap:<context.entity.flag[attackingPlayers]>
      - if <[atkPlayersMap].contains[<player.uuid>]>:
        # player is already on the list, increase their damage
        - define totalDMG:<[atkPlayersMap].get[<player.uuid>].add[<context.damage>]>
        - flag <context.entity> attackingPlayers:<[atkPlayersMap].with[<player.uuid>].as[<[totalDMG]>]>
      - else:
        # player is not on the list, add them to the list
        - flag <context.entity> attackingPlayers:<[atkPlayersMap].include[<player.uuid>=<context.damage>]>
        - narrate "<server.flag[eventTag]> <&r>You've entered the <&d>Dragon Fight<&f>! Attack the dragon to get dragon slayer points!"

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
          - narrate "<server.flag[eventTag]> <reset>You dealt the most damage to the <&d>Dragon<&f>! <&7><&o>+2 points" targets:<player[<[key]>]>

        # give each participant 3 points
        - define participantPoints:<server.flag[dragonEventPoints].get[<[key]>].if_null[0].add[3]>
        - flag server dragonEventPoints:<server.flag[dragonEventPoints].with[<[key]>].as[<[participantPoints]>]>
        - narrate "<server.flag[eventTag]> <reset>You helped slay the <&d>Dragon<&f>! <&7><&o>+3 points" targets:<player[<[key]>]>

      # let all players know a dragon has been defeated
      ## add clickable to view leaderboard in this message
      - narrate "<server.flag[eventTag]> <reset>A <&d>Dragon<&f> was defeated by <&6>@<player.name>" target:<server.online_players>
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
    - define title:<&d><&l>Dragon<&sp>Slayer
    - define values:->:<&sp><&sp><&sp><&sp><&sp><&f><&o>Leaderboard
    - define values:->:<&sp>
    # populate places 1 to 5
    - foreach <[sorted_PointsMap].keys> as:key:
      - if <[loop_index]> < 6:
        - define values:->:<&6>#<[loop_index]><&sp><&e><player[<[key]>].name><&7><&sp>(<server.flag[dragonEventPoints].get[<[key]>]>)
      # obtain the player's place
      - if <[key]> == <[players].uuid>:
        - define personalPlace:<[loop_index]>
    # add a space to make the personal place a footer
    - define values:->:<&sp>
    - define values:->:<&sp><&7><&o>Your<&sp>Score:<&sp>
    # populate player's place
    - define values:->:<&6>#<[personalPlace].if_null[0]><&sp><&e><[players].name><&7><&sp>(<server.flag[dragonEventPoints].get[<[players].uuid>]>)
    # display the sidebar for the player
    - sidebar set title:<[title]> values:<[values]> players:<[players]>
    - wait 180s
    - sidebar remove players:<[players]>

dragonEventCmd:
  type: command
  debug: false
  description: Dragon Slayer Event Commands
  name: dragon
  usage: /dragon [command]
  tab completions:
    1: score|leaderboard<player.has_permission[event.toggle].if_true[|start|reset|stop|resume|].if_false[]>
  script:
  - choose <context.args.first>:
    # returns the number of points from the Points Maptag
    - case score:
      - if !<server.has_flag[dragonEvent]>:
        - narrate "<server.flag[eventTag]> <reset>The <&d>Dragon Slayer<&f> is not active!" targets:<player>
      - else:
        - define points:<server.flag[dragonEventPoints].get[<player.uuid>].if_null[0]>
        - narrate "<server.flag[eventTag]> <reset>You have <[points]> <&d>Dragon Slayer<&f> points!" targets:<player>

    # runs the leaderboard for the player
    - case leaderboard:
      - if !<server.has_flag[dragonEvent]>:
        - narrate "<server.flag[eventTag]> <reset>The <&d>Dragon Slayer<&f> is not active!" targets:<player>
      - else:
        - run dragonleaderboard def:<player>

    # starts the event, resets the point leaderboard
    - case start:
      - if <player.has_permission[event.toggle]>:
        - if <server.has_flag[dragonEvent]>:
          - narrate "<server.flag[eventTag]> An event is ongoing! Please stop it before starting the event! <&7>/dragon stop"
          - stop
        - if <server.has_flag[dragonEventPoints]>:
          - narrate "<server.flag[eventTag]> The leaderboard is full! Please reset it before starting the event! <&7>/dragon reset"
          - stop

        - execute as_server 'cmi broadcast ! <&nl>{#00ff94>}&lHollow Dragon Hunting{#188377} Event Has Begun!&l{#00ff94<} <&nl> '
        - narrate "<server.flag[eventTag]> You have started the event!"
        - flag server dragonEvent
        - flag server dragonEventPoints:<map[]>


    # resets the point leaderboard
    - case reset:
      - if <player.has_permission[event.toggle.admin]>:
        - narrate "<server.flag[eventTag]> You've reset all the event counters! Event status has not changed!"
        - flag server dragonEventPoints:<map[]>

    # stops the event
    - case stop:
      - if <player.has_permission[event.toggle]>:
        - if <server.has_flag[dragonEvent]>:
          - narrate "<server.flag[eventTag]> You have stopped the event! Event will not be tracked. <&nl><&7><&o>To continue the current event, use /dragon resume!"
          - flag server dragonEvent:!
        - else:
          - narrate "<server.flag[eventTag]> There is no event to stop! <&7><&o> To start an event, use /dragon start"

    # resumes the event
    - case resume:
      - if <player.has_permission[event.toggle]> && !<server.has_flag[dragonEvent]>:
        - if <server.has_flag[dragonEventPoints]>:
          - narrate "<server.flag[eventTag]> You have resumed the current event!"
          - flag server dragonEvent
        - else:
          - narrate "<server.flag[eventTag]> There is no event to resume! <&7><&o> To start an event, use /dragon start"