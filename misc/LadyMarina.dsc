#Uses new nickname placeholder instead of flag - depends on /npc nickname --set (name)
Marina:
    type: assignment
    debug: false
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
        - trigger name:proximity state:true radius:5
    interact scripts:
    - LadyMarina_NPC
LadyMarina_NPC:
    type: interact
    debug: false
    steps:
      1:
        proximity trigger:
          entry:
            script:
            - define tag <npc.nickname.parse_color>
            - if <player.has_flag[marinaCD]>:
                - stop
            - flag player marinaCD 20m
            - chat "<[tag]><&f>Good do you have any shulker boxes you would like to sell?"
        click trigger:
            script:
            - if <player.has_flag[npcBusy]>:
              - stop
            - flag player npcBusy expire:1m
            - flag player npcEnableTrade expire:30s
            - define tag '<npc.nickname.parse_color>: '
            - foreach <player.inventory.list_contents> as:checkedItem:
                - if <[checkedItem].material.name.contains[shulker_box]>:
                    - if <[checkedItem].inventory_contents.is_empty>:
                        - flag player countBoxes:++
            - if <player.flag[countboxes]> == 1:
                - narrate "<[tag]><&f>I see you have an empty shulker box."
                - wait 3s
                - narrate "<[tag]><&f>Would you like to trade that in for <gold>⚙<yellow>2 Sigils<white>?"
                - wait 3s
                - narrate "<[tag]><&f>For future reference, I can take multiple shulker boxes at a time."
                - wait 3s
                - narrate "<[tag]><&f>To trade it, hold it in your hand and say yes. <&nl><bold>Click or Say:<reset><&nl><&sp><&sp><&sp><aqua>[<green><element[Yes].on_click[/denizenclickable chat yes]><aqua>]<reset>"
                - wait 3s
                - narrate "<dark_aqua>[<aqua>!]<dark_aqua> <gray>Marina found <player.flag[countboxes]> Shulker boxes to sell!"
                - flag player countboxes:!
                - flag player npcBusy:!
                - stop
            - if <player.flag[countboxes]> > 1:
                - narrate "<[tag]><&f>I see you have <player.flag[countboxes]> empty shulker boxes."
                - wait 3s
                - narrate "<[tag]><&f>Would you like to trade all those in for <gold>⚙<yellow>2 Sigils<white>? a piece?"
                - wait 3s
                - narrate "<[tag]><&f>I can take every shulker box in your inventory or just one."
                - wait 3s
                - narrate "<[tag]><&f>Just say one or all to trade them. <&nl><bold>Click or Say:<reset><&nl><&sp><&sp><&sp><aqua>[<green><element[All].on_click[/denizenclickable chat all]><aqua>]<reset> or <aqua>[<green><element[One].on_click[/denizenclickable chat one]><aqua>]<reset>"
                - wait 3s
                - narrate "<dark_aqua>[<aqua>!]<dark_aqua> <gray>Marina found <player.flag[countboxes]> Shulker boxes to sell!"
                - flag player countboxes:!
                - flag player npcBusy:!
                - stop
            - narrate "<[tag]><&f>I would be happy to buy your unused shulker boxes for <gold>⚙<yellow>2 Sigils<white>? each."
            - wait 2s
            - narrate "<[tag]><&f>Please come back when you have some!"
            - flag player countboxes:!
            - flag player npcBusy:!
        chat trigger:
            1:
                trigger: /all/
                hide trigger message: true
                show as normal chat: false
                script:
                - if <player.has_flag[npcBusy]>:
                   - stop
                - if !<player.has_flag[npcEnableTrade]>:
                   - stop
                - flag player npcBusy expire:5s
                - define tag '<npc.nickname.parse_color>: <&f>'
                - flag player countb:!
                - foreach <player.inventory.list_contents> as:checkedItem:
                    - if <[checkedItem].material.name.contains[shulker_box]>:
                        - if <[checkedItem].inventory_contents.is_empty>:
                          - narrate <[loop_index]>
                          - flag player countb:++
                          - take slot:<[loop_index]>
                          - execute as_server "money give <player.name> 2 Sigils"
                - narrate "<player.flag[countb]> Shulker boxes sold!"
                - flag player countb:!
                - else:
                    - narrate "<[tag]> You don't have any empty shulker boxes I can take right now. Come back and see me later."
                - flag player npcBusy:!
            2:
                trigger: /one|1|yes/
                hide trigger message: true
                show as normal chat: false
                script:
                - if <player.has_flag[npcBusy]>:
                   - stop
                - if !<player.has_flag[npcEnableTrade]>:
                   - stop
                - flag player npcBusy expire:5s
                - define tag '<npc.nickname.parse_color>: <&f>'
                - if <player.item_in_hand.inventory_contents.is_empty> && <player.item_in_hand.material.name.contains[shulker_box]>:
                    - ^take iteminhand
                    - execute as_server "money give <player.name> 2 Sigils"
                - else:
                    - narrate "<[tag]> You are not holding any empty shulker boxes right now. You can hold one out to me and we can try again!"
                    - flag player npcBusy:!