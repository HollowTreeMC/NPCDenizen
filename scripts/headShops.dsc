# spwanHeadShops:
#     type: world
#     events:
#         on player right clicks player_head:
#           - if <player.has_permission[purchaseHeads]>:
#             - if <server.flag[headItem].contains[<context.location>]>:
#                   - define skin <context.location.skull_skin.full>
#                   - narrate <[skin]>
#                   - define url http://textures.minecraft.net/texture/<[skin]>
#                   - give player_head[skull_skin=<[url].proc[url_to_texture_proc]>]
#                 #   - define skin2 <context.location.display_name>
#                 #   - narrate <[skin2]>
#                 #   - define skin2 <context.location.item.display>
#                 #   - narrate <[skin2]>
#                 #   - define skin2 <context.location.name>
#                 #   - narrate <[skin2]>
#                 #   - give player_head[display=Decor;skull_skin=<[skin]>]
#             #   - clickable PromptPurchase save:purchase
#             #   - narrate "<server.flag[infoTag]>Would you like to purchase this head? <aqua>[<dark_aqua><element[Yes].on_click[<entry[purchase].command>]>"
#             - narrate <context.location.skull_skin>
#             - define damager <context.location>
#             - narrate "Damaged <[damager]> <player.name>"


url_to_texture_proc:
  type: procedure
  debug: false
  script:
  - determine 00000000-0000-0000-0000-000000000000|<map[textures=<map[SKIN=<map[url=<[1]>]>]>].to_json.base64_encode>

# # PromptPurchase:
# #   type: task
# #   debug: false
# #   script:
# #     - 