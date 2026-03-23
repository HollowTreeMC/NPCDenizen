eggTracking:
  type: task
  debug: true
  definitions: targetName
  script:
    - if !<server.match_player[<[targetName]>].has_flag[eggCountStart]>:
      - flag <server.match_player[<[targetName]>]> eggCountStart expire:18h
      - flag <server.match_player[<[targetName]>]> eggCount:1
      - define countLeft <server.flag[eggsPlacedCount].sub[<server.match_player[<[targetName]>].flag[eggCount]>]>
      - narrate "<server.flag[infoTag]>You found your first egg for the day! There are <[countLeft]> eggs left to find!" targets:<server.match_player[<[targetName]>]>
      - stop
    - if <server.match_player[<[targetName]>].flag[eggCount]> != <server.flag[eggsPlacedCount]>:
      - if <server.match_player[<[targetName]>].flag[eggCount]> < <server.flag[eggsPlacedCount].sub[1]>:
        - flag <server.match_player[<[targetName]>]> eggCount:++
        - define countLeft <server.flag[eggsPlacedCount].sub[<server.match_player[<[targetName]>].flag[eggCount]>]>
        - wait 3s
        - narrate "<server.flag[infoTag]>You have <[countLeft]> eggs left to find!" targets:<server.match_player[<[targetName]>]>
        - stop
      - else:
        - flag <server.match_player[<[targetName]>]> eggCount:++
    - if <server.match_player[<[targetName]>].has_flag[allEggsFound]>:
      - narrate "<server.flag[infoTag]> Wow you found a bonus egg!"
      - stop
    - if <server.match_player[<[targetName]>].flag[eggCount]> == <server.flag[eggsPlacedCount]>:
      - flag <server.match_player[<[targetName]>]> allEggsFound expire:17h
      - wait 3s
      - narrate "<server.flag[infoTag]>You found your last egg! There are no more eggs left to hunt for. Come back tomorrow for more goodies!" targets:<server.match_player[<[targetName]>]>
      - wait 4s
      - narrate "<server.flag[infoTag]>Here's a key for finding all your eggs for the day!" targets:<server.match_player[<[targetName]>]>
      - execute as_server "crates giveKey EasterEgg2025 <[targetName]>"