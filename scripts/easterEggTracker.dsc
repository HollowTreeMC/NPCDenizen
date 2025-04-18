eggTracking:
  type: task
  debug: true
  definitions: targetName
  script:
    - if !<server.match_player[<[targetName]>].has_flag[eggCountStart]>:
      - flag <server.match_player[<[targetName]>]> eggCountStart expire:23h
      - flag <server.match_player[<[targetName]>]> eggCount:1
      - define countLeft <server.flag[eggsPlacedCount].sub[<server.match_player[<[targetName]>].flag[eggCount]>]>
      - narrate "<server.flag[infoTag]> You found your first egg for the day! There are <[countLeft]> eggs left to find!" targets:<server.match_player[<[targetName]>]>
      - stop
    - if <server.match_player[<[targetName]>].flag[eggCount]> < <server.flag[eggsPlacedCount]>:
      - flag <server.match_player[<[targetName]>]> eggCount:++
      - define countLeft <server.flag[eggsPlacedCount].sub[<server.match_player[<[targetName]>].flag[eggCount]>]>
      - narrate "<server.flag[infoTag]> You have <[countLeft]> eggs left to find!" targets:<server.match_player[<[targetName]>]>
    - if <server.match_player[<[targetName]>].flag[eggCount]> == <server.flag[eggsPlacedCount]>:
      - narrate "<server.flag[infoTag]> You found your last egg! There are no more eggs left to hunt for. Come back tomorrow for more goodies!" targets:<server.match_player[<[targetName]>]>