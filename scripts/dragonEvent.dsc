# Listens for the player damaging the ender dragon
Dragon_Listener_World:
  type: world
  debug: false
  events:
    on player damages ender_dragon:
    - if <server.has_flag[hollow_event]>:
      - if <player.has_flag[nohollowevent]>:
        - narrate "If you wish to rejoin the dragon hunt, use command /HollowEvent join!"
        - if !<player.has_flag[notiAttackCD]>:
          - narrate "<dark_aqua>[<dark_red>!<dark_aqua>] <reset>You've hit the dragon but you are not currently part of the event, if you wish to join, use command /HollowEvent join!"
          - flag player notiAttackCD 5m
        - stop
      - if !<context.entity.has_flag[attackingPlayers]>:
        - foreach <server.online_player:
          - if !<player.has_flag[nohollowevent]>:
            - narrate "<server.flag[eventTag]> &rA Dragon fight has started! Get your points by attacking the dragon too!"
        - flag <context.entity> attackingPlayers:->:<player>
        - narrate "<server.flag[eventTag]> <reset>You've hit the dragon. You are flagged as an attacking player. Kill the dragon to get points toward the event!"
        - flag player notiAttackCD duration:5m
      - if !<context.entity.flag[attackingPlayers].contains[<player>]> && !<player.has_flag[nohollowevent]> || <context.entity.has_flag[attackingPlayers]>:
        - flag <context.entity> attackingPlayers:->:<player>
        - narrate "<server.flag[eventTag]> <reset>You've hit the dragon. You are flagged as an attacking player. Kill the dragon to get points toward the event!"
      - flag player damage_dealt_<context.entity>:+:<context.damage>
      - if !<context.entity.has_flag[highestDamager]>:
        - flag <context.entity> highestDamager:<player>
        - stop
      - if <player> != <context.entity.flag[highestDamager]>:
        - define highestDMGER <player[<context.entity.flag[highestDamager]>]>
        - if <player.flag[damage_dealt_<context.entity>]> > <[highestDMGER].flag[damage_dealt_<context.entity>]>:
          - define highestDMGER <player>
          - flag <context.entity> highestDamager:<player>

#Listens for dragon dying
Dragon_Death_Listener_World:
  type: world
  debug: false
  events:
    after player kills ender_dragon:
    - if <server.has_flag[hollow_event]>:
      - define mostDMG 0
      - define highestDMGER <player[<context.entity.flag[highestDamager]>]>
      - narrate "<server.flag[eventTag]> <reset>You dealt the highest damage and received an extra 2 points!" targets:<[highestDMGER]>
      - flag <context.entity.flag[highestDamager]> enderDragonsKilled:+:2
      - foreach <context.entity.flag[attackingPlayers]>:
        - flag player damage_dealt_<context.entity>:!
        - define killer <player[<[value]>]>
        - flag <[killer]> enderDragonsKilled:+:5
        - narrate "<&a><&l>Hollowtree Dragon Event:<&nl> <&2>Dragon Points: <&a><[killer].flag[enderDragonsKilled]>" target:<[killer]>
        - run CheckTop def:<[killer]>
        - wait 1s
      - foreach <server.online_players>:
        - if !<[value].has_flag[nohollowevent]>:
          - narrate "<server.flag[eventTag]> <reset>An ender dragon was defeated! <dark_aqua><[highestDMGER].name><reset> was awarded <dark_green>7 <reset>points for the highest damage<aqua>!" target:<[value]>
          - if !<[value].has_flag[notiTotals]>:
            - narrate "<&7><&o>To view the event leaderboard, use /HollowEvent sidebar" target:<[value]>
            - flag <[value]> notiTotals expire:20m
CheckTop:
  type: task
  debug: false
  definitions: killer
  script:
    - if <[killer].flag[enderDragonsKilled]> > <server.flag[ph5]>:
      - if <[killer].flag[enderDragonsKilled]> > <server.flag[ph1]>:
          - run Set1stPlace def:<[killer]>
          - stop
      - else if <[killer].flag[enderDragonsKilled]> > <server.flag[ph2]>:
          - run Set2ndPlace def:<[killer]>
          - stop
      - else if <[killer].flag[enderDragonsKilled]> > <server.flag[ph3]>:
          - run Set3rdPlace def:<[killer]>
          - stop
      - else if <[killer].flag[enderDragonsKilled]> > <server.flag[ph4]>:
          - run Set4thPlace def:<[killer]>
          - stop
      - else if <[killer].flag[enderDragonsKilled]> > <server.flag[ph5]>:
          - flag server ph5:<[killer].flag[enderDragonsKilled]>
          - flag server name5th:<[killer].name>
    - flag <[killer]> sidebarStick duration:60s
    - run Sidebar_handler
    - wait 60s
    - sidebar remove

#Listener for dragon kills
#Once the players take their places on the top 5, the scoreboard is updated for everyone with the flag that they enable when they use the command /hollowevent sidebar
#Placeholder handler to set each player to the proper place on the top 5 chart
Set1stPlace:
  type: task
  debug: false
  definitions: killer
  script:
    - if <[killer].name> == <server.flag[name2nd]>:
      - flag server ph2:<server.flag[ph1]>
      - flag server name2nd:<server.flag[name1st]>
    - if <[killer]> == <server.flag[name3rd]>:
      - flag server ph3:<server.flag[ph2]>
      - flag server name3rd:<server.flag[name2nd]>
      - flag server ph2:<server.flag[ph1]>
      - flag server name2nd:<server.flag[name1st]>
    - if <[killer]> == <server.flag[name4th]>:
      - flag server ph4:<server.flag[ph3]>
      - flag server name4th:<server.flag[name3rd]>
      - flag server ph3:<server.flag[ph2]>
      - flag server name3rd:<server.flag[name2nd]>
      - flag server ph2:<server.flag[ph1]>
      - flag server name2nd:<server.flag[name1st]>
    - if <[killer]> == <server.flag[name5th]>:
      - flag server ph5:<server.flag[ph4]>
      - flag server name5th:<server.flag[name4th]>
      - flag server ph4:<server.flag[ph3]>
      - flag server name4th:<server.flag[name3rd]>
      - flag server ph3:<server.flag[ph2]>
      - flag server name3rd:<server.flag[name2nd]>
      - flag server ph2:<server.flag[ph1]>
      - flag server name2nd:<server.flag[name1st]>
    - flag server ph1:<[killer].flag[enderDragonsKilled]>
    - flag server name1st:<[killer].name>
    - run Sidebar_handler

Set2ndPlace:
  type: task
  debug: false
  definitions: killer
  script:
    - if <[killer].name> == <server.flag[name3rd]>:
      - flag server ph3:<server.flag[ph2]>
      - flag server name3rd:<server.flag[name2nd]>
    - if <[killer]> == <server.flag[name4th]>:
      - flag server ph4:<server.flag[ph3]>
      - flag server name4th:<server.flag[name3rd]>
      - flag server ph3:<server.flag[ph2]>
      - flag server name3rd:<server.flag[name2nd]>
    - if <[killer]> == <server.flag[name5th]>:
      - flag server ph5:<server.flag[ph4]>
      - flag server name5th:<server.flag[name4th]>
      - flag server ph4:<server.flag[ph3]>
      - flag server name4th:<server.flag[name3rd]>
      - flag server ph3:<server.flag[ph2]>
      - flag server name3rd:<server.flag[name2nd]>
    - flag server ph2:<[killer].flag[enderDragonsKilled]>
    - flag server name2nd:<[killer].name>
    - run Sidebar_handler

Set3rdPlace:
  type: task
  debug: false
  definitions: killer
  script:
    - if <[killer].name> == <server.flag[name4th]>:
      - flag server ph4:<server.flag[ph3]>
      - flag server name4th:<server.flag[name3rd]>
    - if <[killer]> == <server.flag[name5th]>:
      - flag server ph5:<server.flag[ph4]>
      - flag server name5th:<server.flag[name4th]>
      - flag server ph4:<server.flag[ph3]>
      - flag server name4th:<server.flag[name3rd]>
    - flag server ph3:<[killer].flag[enderDragonsKilled]>
    - flag server name3rd:<[killer].name>
    - run Sidebar_handler

Set4thPlace:
  type: task
  debug: false
  definitions: killer
  script:
    - if <[killer].name> == <server.flag[name5th]>:
      - flag server ph5:<server.flag[ph4]>
      - flag server name5th:<server.flag[name4th]>
    - flag server ph4:<[killer].flag[enderDragonsKilled]>
    - flag server name4th:<[killer].name>
    - run Sidebar_handler


#Start, Stop, reset, sidebar, and count cmds

#permissions seperate for the administrative cmds and the player cmds
hollow_event_CMDs:
  type: command
  debug: false
  description: Command handler for hollow event
  name: hollowevent
  usage: /hollowevent [command]
  tab completions:
      1: count|sidebar|score|join|leave
  script:
    - define argument <context.args.get[1]>
    - choose <context.args.first>:
      - case stop:
        - if <player.has_permission[event.toggle]>:
          - if <player.has_permission[event.toggle]>:
            - narrate "<server.flag[eventTag]> You have stopped the event! Event will not be tracked, no points will be reset. <&nl>This is for debugging! Use /hollowevent reset to reset all totals! <&nl><&6>To continue the current event, use /HollowEvent continue!"
            - flag server hollow_event:!
      - case pause:
        - if <player.has_permission[event.toggle]>:
          - if <player.has_permission[event.toggle]>:
            - narrate "<server.flag[eventTag]> You have stopped the event! Event will not be tracked. <&nl><&6>To continue the current event, use /HollowEvent continue!"
            - flag server hollow_event:!
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
          - flag server hollow_event:!
      - case start:
        - if <player.has_permission[event.toggle]> && !<server.has_flag[hollow_event]>:
          - execute as_server 'cmi broadcast !<&8>---------------------------------------<&nl>{#00ff94>}&lHollow Dragon Hunting{#188377<>} Event Has Begun!&l{#00ff94<} <&nl><&nl><&r>{#188377}<&l>Dragon slayers<reset> will be awarded <dark_green>5<reset> points per kill and <aqua>2<reset> extra points will be awarded to the <bold>highest damager<aqua>!<reset><&nl><&nl>Kill {#00ff94}dragons <reset>to earn your place on the {#00ff94}<&l>Leaderboard<&color[#00e6ca]>! <&nl><&nl>Use command {#00ff94}/HollowEvent sidebar <&color[#00e6ca]>to view the leaderboard and {#00ff94}/HollowEvent count <&color[#00e6ca]>for your totals!<&nl><&a>| <&7><&o>To opt out, use the command /HollowEvent leave!<&a> | <&8>---------------------------------------'
          - flag server hollow_event
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
          - flag server hollow_event
          - narrate "<server.flag[eventTag]> You have resumed the current event!"
      - case count:
        - if <server.has_flag[hollow_event]>:
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
          - if <server.has_flag[hollow_event]> && !<player.has_flag[noHollowEvent]>:
            - flag player sidebarStickOn duration:5d
            - run Sidebar_handler_personal def:<player>
            - narrate "<server.flag[eventTag]> Enabling sidebar! <&nl><&7><&o>/hollowevent sidebar to disable."
          - else if !<server.has_flag[hollow_event]>:
            - narrate "<server.flag[eventTag]> No event is currently active!"
            - sidebar remove
            - flag <player> sidebarStickOn:!
      - case score:
        - if <server.has_flag[hollow_event]> && !<player.has_flag[noHollowEvent]>:
          - if <player.has_flag[enderDragonsKilled]>:
            - narrate "<&a><&l>Your current dragon hunting event total:<&nl> <&2>Killed: <&a><player.flag[enderDragonsKilled]>"
          - run Sidebar_handler
          - wait 60s
          - sidebar remove
        - else if !<server.has_flag[hollow_event]>:
          - narrate "<server.flag[eventTag]> No event is currently active!"
        - else if !<player.has_flag[noHollowEvent]>:
          - narrate "<server.flag[eventTag]> The event is not currently active for you! /HollowEvent join to rejoin the hunt!"
      - case leave:
        - if <server.has_flag[hollow_event]>:
          - flag player noHollowEvent expire:5d
          - narrate "<server.flag[eventTag]> You have opted out of the dragon hunting event! To join back, use the command /HollowEvent join."
      - case join:
        - if <server.has_flag[hollow_event]>:
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