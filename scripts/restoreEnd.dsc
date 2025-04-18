# DragonListen:
#   type: world
#   debug: false
#   events:
#     on ender_dragon spawns:
#     #   - if <server.flag[hollow_event]>:
#         - wait 20s
#         - run RestoreEnd
#         - narrate "Dragon spawned, resetting started... cause is <context.reason>" target:<server.match_player[kirrasio]>
RestoreEnd:
  type: task
  debug: true
  script:
    - worldedit paste file:FixEndHub position:<location[FixEndLoc]>
