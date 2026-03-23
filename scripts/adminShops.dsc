EntersAdminShop:
  type: world
  debug: false
  events:
    on player enters adminshops:
    - if !<player.has_permission[cmi.command.portal.adminshop]>:
      - wait 4t
      - execute as_server "cmi back <player.name>"
      - narrate "<dark_aqua>[<aqua>!<dark_aqua>] <reset>You do not have permission to be in the admin shops area!"
      - wait 3s
      - narrate "<dark_aqua>[<aqua>!<dark_aqua>] <reset>Come back when you have reached Chronarch rank or have purchased a shop pass!"
      - wait 3s