#Uses new nickname placeholder instead of flag - depends on /npc nickname --set (name)
Nara:
    type: assignment
    debug: false
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true cooldown:false radius:5
        - trigger name:proximity state:true radius:5
    interact scripts:
    - LadyMarina_NPC

Nara_Main:
    type: interact
    debug: false
    steps:
      1:
        proximity trigger:
          entry:
            script:
            - if <player.has_flag[NaraCD]>:
                - stop
            - flag player NaraCD 5m
            - random:
              - narrate "<server.flag[pfx_Nara]> Welcome, I'm working on some new parts for the 'inators'."
              - narrate "<server.flag[pfx_Nara]> Have you found Petinator yet? He's my newest."
              - narrate "<server.flag[pfx_Nara]> Looking for something good?."
            - narrate "<server.flag[pfx_Nara]> Anyway if you'd like to sell some shulker boxes, just drop by anytime and talk to me."
        click trigger:
            script:
            - if <player.has_flag[npcBusy]>:
              - stop
            - flag player npcBusy expire:1m
            - flag player npcEnableTrade expire:30s
            - foreach <player.inventory.list_contents> as:checkedItem:
                - if <[checkedItem].material.name.contains[shulker_box]>:
                    - if <[checkedItem].inventory_contents.is_empty>:
                        - flag player countBoxes:++
            - if <player.flag[countboxes]> == 1:
                - narrate "<server.flag[pfx_Nara]> You've got a shulker boxe there in your inventory."
                - wait 3s
                - narrate "<server.flag[pfx_Nara]> Would you like to trade that in for <gold>⚙<yellow>2 Sigils<white>?"
                - wait 3s
                - narrate "<server.flag[pfx_Nara]> To trade it, hold it in your hand and say yes. <&nl><bold>Click or Say:<reset><&nl><&sp><&sp><&sp><aqua>[<green><element[Yes].on_click[/denizenclickable chat yes]><aqua>]<reset>"
                - wait 3s
                - narrate "<dark_aqua>[<aqua>!]<dark_aqua> <gray>Nara found <player.flag[countboxes]> Shulker boxes to sell!"
                - flag player countboxes:!
                - flag player npcBusy:!
                - stop
            - if <player.flag[countboxes]> > 1:
                - narrate "<server.flag[pfx_Nara]> So you have... <player.flag[countboxes]> empty shulker boxes."
                - wait 3s
                - narrate "<server.flag[pfx_Nara]> Would you like to trade all those in for <gold>⚙<yellow>2 Sigils<white> a piece?"
                - wait 3s
                - narrate "<server.flag[pfx_Nara]> I can take every shulker box in your inventory or just one."
                - wait 3s
                - narrate "<server.flag[pfx_Nara]> Just say one or all to trade them. <&nl><bold>Click or Say:<reset><&nl><&sp><&sp><&sp><aqua>[<green><element[All].on_click[/denizenclickable chat all]><aqua>]<reset> or <aqua>[<green><element[One].on_click[/denizenclickable chat one]><aqua>]<reset>"
                - wait 3s
                - narrate "<dark_aqua>[<aqua>!]<dark_aqua> <gray>Nara found <player.flag[countboxes]> Shulker boxes to sell!"
                - flag player countboxes:!
                - flag player npcBusy:!
                - stop
            - narrate "<server.flag[pfx_Nara]> I would be happy to buy your unused shulker boxes for <gold>⚙<yellow>2 Sigils<white> each."
            - wait 2s
            - narrate "<server.flag[pfx_Nara]> Please come back when you have some!"
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
                - define pfx_ladymarina '<npc.nickname.parse_color>: <&f>'
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
                    - narrate "<[pfx_ladymarina]> You don't have any empty shulker boxes I can take right now. Come back and see me later."
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
                - define pfx_ladymarina '<npc.nickname.parse_color>: <&f>'
                - if <player.item_in_hand.inventory_contents.is_empty> && <player.item_in_hand.material.name.contains[shulker_box]>:
                    - ^take iteminhand
                    - execute as_server "money give <player.name> 2 Sigils"
                - else:
                    - narrate "<[pfx_ladymarina]> You are not holding any empty shulker boxes right now. You can hold one out to me and we can try again!"
                    - flag player npcBusy:!