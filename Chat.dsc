## Chat Manager Script
# Intercept messages before they are sent to the chat unless they are to an npc
# Filter messages for spam or bad words, warn offending players with litebans
# Generate prefixes and color the chat
# Send messages to the server with ability for staff to delete the message
# Send global chat messages to the rest of the bungee(?)

ChatControl:
    type: world
    debug: false
    events:
        on player chats:
            - determine passively cancelled

            # record messages as player flags, record brief history
            - if <player.has_flag[Chat_1]>:
                - flag <player> Chat_2:<player.flag[Chat_1]>
            - if <player.has_flag[Chat_0]>:
                - flag <player> Chat_1:<player.flag[Chat_0]>
            - flag <player> Chat_0:<context.message>

            - flag <player> 

            ## optionally record to DB? may be unnecessary with CO

            ## MESSAGE CHECKS
            # SPAM - Compare for similarity with the last two messages
            - if <player.has_flag[Chat_2]>:
                - if <player.flag[Chat_0]>:
                    - if <player.flag[Chat_0].difference[<player.flag[Chat_1]>]> < 4 || <player.flag[Chat_0].difference[<player.flag[Chat_2]>]> < 4:
                        - narrate "<gray>Please do not send duplicate or repetitive messages!"
                        - stop

            # RATE - If player is sending messages too fast, rate limit them

            # SWEAR - Censor bad words with *, warn with litebans, ban for slurs
            - foreach <script[chat_data].data_key[bad_words]> as:word:
            - if <define[lower_text].contains_text[<define[word]>]>:
                - narrate "<red>Your message contained inappropriate language and was blocked."
                - stop

            # CAPS - IF message > 60% caps, make lowercase

            ## MESSAGE GENERATOR

        # Generate a unique ID for this message so it can be targeted for deletion
        - define msg_id <util.random_uuid>

        - define prefix <player.group.capitalized||Player>
        - define name <player.name>

        # 1. Staff Chat Channel
        - if <define[text].starts_with[#]>:
        - if <player.has_permission[chat.staff]>:
            - define msg <define[text].after[#].strip_color>
            - define staff_format "<red>[Staff] <gold><define[name]>: <white><define[msg]>"
            - announce <define[staff_format]> to_permission:chat.staff
            - stop
        - else:
            - narrate "<red>You do not have permission to use the staff channel."
            - stop

        # 2. Global Chat Setup with Clickable Deletion
        # Format components using Element Tag formatting
        - define delete_btn "<red><bold>[X] <reset>"
        - define delete_btn <define[delete_btn].on_click[/denizen_delete_msg <define[msg_id]>].on_hover[Click to delete this message]>
        
        - define message_content "<gray>[<yellow><define[prefix]><gray>] <white><define[name]>: <gray><define[text]>"

        # Send formatted message to staff (with [X]) vs non-staff (without [X])
        - foreach <server.online_players> as:target:
        - if <define[target].has_permission[chat.staff]>:
            - narrate <define[delete_btn].append[<define[message_content]>]> targets:<define[target]> per_player_message_id:<define[msg_id]>
        - else:
            - narrate <define[message_content]> targets:<define[target]> per_player_message_id:<define[msg_id]>

ChatFilter:
    type: data
    bad_words:
        - badword1
        - badword2
        - badword3




ChatDelete:
    type: command
    name: denizen_delete_msg
    description: Internal command for chat message deletion
    usage: /denizen_delete_msg [id]
    permission: chat.staff
    script:
        - if <context.args.is_empty>:
        - stop
        - define target_id <context.args.get[1]>
        
        # Delete the message across all online players using the message ID
        - adjust <server.online_players> remove_specific_chat_message:<define[target_id]>
        
        # Notify the staff member who deleted it
        - narrate "<red>[Staff] Message deleted."