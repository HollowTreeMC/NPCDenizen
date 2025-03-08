joinServer:
  type: world
  debug: false
  events:
    on player joins:
      - ratelimit <player> 10s
      - if <player.has_flag[autoWeatheroffOff]>:
        - execute as_op "pweather clear"

WeatherOff:
  type: command
  description: Weather Removeith
  name: weatheroff
  permission: godLordOfAll
  debug: false
  usage: /weatheroff <&lt>true<&gt> | <&lt>cancel<&gt>
  script:
    - ratelimit <player> 2s
    - choose <context.args.get[1]>:
      - case always:
        - flag player autoWeatheroffOff
        - execute as_op "pweather clear"
        - narrate "<&3>[<&b><&l>!<&3>]<&r> No more rain time ever!"
      - case cancel:
        - flag player autoWeatheroffoff:!
        - execute as_op "pweather reset"
        - narrate "<&3>[<&b><&l>!<&3>]<&r> Weather is back on. Idk why though, seems questionable to me."
      - default:
        - if <player.has_flag[autoWeatheroffOff]>:
          - flag player autoWeatheroffoff:!
          - execute as_op "pweather reset"
          - narrate "<&3>[<&b><&l>!<&3>]<&r> Weather is back on. Idk why though, seems questionable to me."
        - else:
          - flag player autoWeatheroffOff
          - execute as_op "pweather clear"
          - narrate "<&3>[<&b><&l>!<&3>]<&r> No more rain time ever!"
#checkjob (job)
CheckJob:
  type: command
  debug: false
  description: Use /checkjob (job)
  name: checkjob
  permission: godLordOfAll
  usage: /checkjob [job]
  script:
  - define maxjobs 1
  - if <player.has_permission[jobs.max.2]>:
    - define maxjobs 2
  - if <player.has_permission[jobs.max.3]>:
    - define maxjobs 3
  - define specifiedJob <context.args.get[1]>
  - flag player countjobs:0
  - foreach <player.current_jobs> as:job:
      - flag player countjobs:++
      - if <[job].contains[<[specifiedJob]>]>:
        - narrate true
      - else:
        - narrate <[job]>
        - narrate <[specifiedJob]>
  - narrate <player.flag[countjobs]>
  - if <player.flag[countjobs]> >= <[maxjobs]>:
    - narrate "You have the max amount of jobs -rest of script here"
  - flag player !countjobs