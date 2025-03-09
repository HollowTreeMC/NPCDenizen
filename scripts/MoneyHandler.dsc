MoneyGiveAll:
  type: command
  description: Send money with defined amount and type
  name: MoneyGiveAll
  permission: developerLords.money
  debug: false
  usage: /MoneyGiveAll type amount
  script:
    - define tag <dark_aqua>[<aqua>!<dark_aqua>]<white>
    - define type <context.args.get[1]>
    - if <[type]> == null:
      - narrate "<[tag]><red>type is missing'<red>'."
      - stop
    - define amount <context.args.get[2]>
    - if <[amount]> == null:
      - narrate "<[tag]><red>amount is missing'<red>'."
      - stop
    - if <[type]> != coins:
      - narrate "<[tag]><red> The type <[type]> is not valid."
      - narrate "<[tag]> Please submit a valid currency to pay players with<red>!"
      - stop
    - foreach <server.online_players>:
      - execute as_server "money give <[value].name> <[amount]> <[type]>"
    - narrate "<[tag]>All players have been paid <[amount]> <[type]>!"