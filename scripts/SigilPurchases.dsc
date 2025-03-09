SigilPurchase:
  type: command
  description: Purchase head command
  name: SigilPurchase
  permission: godLordOfAll
  debug: false
  usage: /SigilPurchase headID playerName price
  script:
    - define tag <dark_aqua>[<aqua>!<dark_aqua>]<white>
    - define targetUser <server.match_player[<context.args.get[2]>].if_null[null]>
    - if <[targetUser]> == null:
      - narrate "<[tag]><red>Unknown player '<yellow><context.args.get[2]><red>'."
      - stop
    - define targetName <context.args.get[2]>
    - define price <context.args.get[3]>
    - if <[price]> == null:
      - narrate "<[tag]><red>Invalid Price '<yellow><context.args.get[3]><red>'. <&nl><reset><gray><italic>Command Usage: /SigilPurchase headID playerName price"
      - stop
    - define sigilCount <placeholder[tne_currency_Sigils].player[<[targetUser]>]>
    - if <[sigilCount]> < 5:
      - narrate "<[tag]> Sorry <[targetName]>, you only have <bold><[sigilCount]><reset> Sigils<bold>.<reset> <&nl>This item costs <aqua><bold>5<reset> Sigils<aqua><bold>!<reset> Check back in when you have more<aqua>." targets:<[targetUser]>
      - stop
    - define headID <context.args.get[1]>
    - clickable AcceptPurchase save:accept until:20s def.targetName:<[targetName]> def.targetUser:<[targetUser]> def.tag:<[tag]> def.price:<[price]> def.headID:<[headID]>
    - narrate "<[tag]><&f> <&color[#ccfffc]>You are about to purchase this collectable, please click <aqua>[<blue><element[Accept].on_click[<entry[accept].command>]><aqua>]<reset> to confirm." targets:<[targetUser]>

AcceptPurchase:
  type: task
  debug: false
  definitions: targetName|targetUser|tag|price|headID
  script:
    - execute as_server "hdb give <[headID]> 1 <[targetName]>"
    - execute as_server "money take <[targetName]> <[price]> Sigils"
    - narrate "<[tag]> Hooray <[targetName]>! You have obtained a new collectable<aqua><bold>!" targets:<[targetUser]>