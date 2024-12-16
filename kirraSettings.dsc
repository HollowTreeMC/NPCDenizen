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
  usage: /weatheroff
  script:
    - ratelimit <player> 10s
    - choose <context.args.get[1]>:
      - case always:
        - if <player.has_permission[godLordOfAll.always]>:
          - flag player autoWeatheroffOff
          - execute as_op "pweather clear"
          - narrate "<&3>[<&b><&l>!<&3>]<&r> No more rain time ever<&lt>3"
      - case once:
        - execute as_op "pweather clear"
        - narrate "<&3>[<&b><&l>!<&3>]<&r> Weather off for right now, toggle it permenantly with /weatheroff always."
      - case off:
        - flag player autoWeatheroffoff:!
        - narrate "<&3>[<&b><&l>!<&3>]<&r> Weather is back on. Idk why though, seems questionable to me."