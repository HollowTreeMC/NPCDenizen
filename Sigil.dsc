## HollowCraft Sigil Economy Script
# This script is a local economy system which loads data from a global source (database) upon player joins / quits. The primary function of Sigils are to be used in other Denizen scripts, so they do not need to emulate an actual economy.

## Flags used in this file
# <player.flag[Sigils]> is an int - returns the number of sigils the player has
# %denizen_<player.flag[Sigils]>% to use as a read-only PAPI

## Permissions in this file
# sigil.helper - grants /bal auditing commands
# sigil.admin - grants additional admin commands

SigilDBLoad:
    type: world
    debug: false
    events:
        on server start:
        # prefix for all sigil messages
        - flag server sigilTag:<&8>[<&e><&l>ღ<&8>]<&7>
        - flag server sigilSym:<&e><&l>ღ<&r><&7>

        # load credentials from config
        - if !<util.has_file[sigildb.yml]>:
            # create config file if there is none
            - yaml create id:sigildb
            - yaml id:sigildb set name:s0_dbname
            - yaml id:sigildb set address:192.168.86.185:3306
            - yaml id:sigildb set username:username_credential
            - yaml id:sigildb set "password:update the password in the secrets file in the format - sigildb: password"
            - ~yaml savefile:sigildb.yml id:sigildb

            # send message to console, Sigil DB not loaded!
            - debug error "Sigils database credentials were not found! Please enter credentials in plugins/Denizen/SigilDB.yml"

        - else:
            # load db login information from the config file
            - ~yaml load:sigildb.yml id:sigildb
            - define name:<yaml[sigildb].read[name]>
            - define address:<yaml[sigildb].read[address]>
            - define username:<yaml[sigildb].read[username]>

            # establish connection with the database
            - ~sql id:sigildb connect:<[address]>/<[name]>?autoReconnect=true username:<[username]> password:<secret[sigildb]>
            - debug "Sigils database sucessfully loaded!"

            # sigil database table creation command
            ## /ex sql id:sigildb "update:CREATE TABLE sigils (uuid TEXT, sigils INTEGER);"

        # send message to console, DB connection not established!
        on script generates error:
        - debug error "Error occured in Sigil script! Please check the credentials in plugins/Denizen/SigilDB.yml! Line: <context.line>, <context.message>"
        - stop

        on player join:
        # check how many sigils a player has
        - ~sql id:sigildb "query:SELECT sigils FROM sigils WHERE uuid='<player.uuid>'" save:query_result

        # create an entry in the table if the player does not currently exist
        - if <entry[query_result].result_list.is_empty>:
            - ~sql id:sigildb "update:INSERT INTO sigils VALUES ('<player.uuid>',0);"
            - debug '[Sigils] Created new entry for <player.name>!'
            # set player flag
            - flag <player> Sigils:0
        - else:
            # set player flag
            - flag <player> Sigils:<entry[query_result].result_list.get[1].get[1]>

        on delta time minutely:
        # update the local flags for all online players
        # for passing through updates from other servers
        - foreach <server.online_players> as:player_to_query:
            - ~sql id:sigildb "query:SELECT sigils FROM sigils WHERE uuid='<[player_to_query].uuid>'" save:loop_query_result
            - flag <[player_to_query]> Sigils:<entry[loop_query_result].result_list.get[1].get[1]>

## Function to run in order to add entries for all existing players into the database. Should only be used once when initilizing the system for the first tiime.
#SigilDBQLogPlayers:
#    type: task
#    debug: false
#    enabled: false
#    script:
#        - foreach <server.offline_players> as:player_to_query:
#            # create an entry in the table if the player does not currently exist
#            - ~sql id:sigildb "query:SELECT sigils FROM sigils WHERE uuid='<[player_to_query].uuid>'" save:query_result
#
#            - if <entry[query_result].result_list.is_empty>:
#                - ~sql id:sigildb "update:INSERT INTO sigils VALUES ('<player.uuid>',0);"
#                - debug '[Sigils] Created new entry for <[player_to_query].name>!'
#                # set player flag
#                - flag <[player_to_query]> Sigils:0
#            - else:
#                # set player flag
#                - flag <[player_to_query]> Sigils:<entry[query_result].result_list.get[1].get[1]>


# Looks up the player's balance AND updates the player's local flag
SigilDBQuery:
    type: task
    debug: false
    definitions: Player[<player> tag]
    script:
        - ~sql id:sigildb "query:SELECT sigils FROM sigils WHERE uuid='<[Player].uuid>'" save:query_result
        - flag <[player]> Sigils:<entry[query_result].result_list.get[1].get[1]>
        - determine <entry[query_result].result_list.get[1].get[1]>

# Sets the player's balance AND updates the player's local flag
SigilDBSet:
    type: task
    debug: false
    definitions: Player[<player> tag]|Value[Int]
    script:
        - ~sql id:sigildb "update:UPDATE sigils SET sigils=<[Value]> WHERE uuid='<[Player].uuid>';"
        - flag <[player]> Sigils:<[Value]>


SigilCMD:
    type: command
    debug: false
    description: Sigil Commands
    name: sigil
    usage: /sigil [argument]
    tab complete:
    - choose <context.raw_args.to_list.count[ ]>:
        ## First argument
        # gives players options: help, balance, send, top
        # gives admins options: set, take, give
        - case 0:
            - define first <list[help|balance|bal|send|top]>
            - if <player.has_permission[sigil.admin]>:
                - define first <[first].include[set|take|give]>
            - determine <[first]>
        ## Second argument
        # gives players <server.online> option if: send
        # gives helpers <server.player> if: balance
        # gives admins <server.player> if: set, take, give
        - case 1:
            - define first_check <list[send]>
            - if <player.has_permission[sigil.helper]>:
                - define first_check <[first_check].include[balance|bal]>
                - if <player.has_permission[sigil.admin]>:
                    - define first_check <[first_check].include[set|take|give]>

                # return server.player to player with perms
                - if <context.args.get[1].exists>:
                    - if <[first_check].contains[<context.args.first>]>:
                        - if <context.args.get[2].exists>:
                            - determine <server.players.parse_tag[<[parse_value].name>].filter_tag[<[filter_value].starts_with[<context.args.get[2]>]>]>
                        - else:
                            - determine <server.players.parse_tag[<[parse_value].name>]>

                # return server.online to player with no perms
                - else:
                    - if <context.args.get[2].exists>:
                        - determine <server.online_players.parse_tag[<[parse_value].name>].filter_tag[<[filter_value].starts_with[<context.args.get[2]>]>]>
                    - else:
                        - determine <server.online_players.parse_tag[<[parse_value].name>]>

    script:
    ## Player Commands
    - if !<context.args.first.exists>:
        - execute as_player 'sigil help'
        - stop

    - choose <context.args.first>:
        # return an explanation of each of the commands
        - case help:
            - narrate "<server.flag[sigilTag]> HollowCraft Sigils"
            - narrate "<&e>/sigil balance <&f>to view your sigil balance"
            - narrate "<&e>/sigil send [player] [amount] <&f>to send sigils to other players"
            - narrate "<&e>/sigil top <&f>to view the sigil leaderboard"
            - if <player.has_permission[sigil.admin]>:
                - narrate "<&e>/sigil set [player] [amount] <&f>to set the sigil balance of a player"
                - narrate "<&e>/sigil take [player] [amount] <&f>to take sigils from a player"
                - narrate "<&e>/sigil give [player] [amount] <&f>to give sigils to a player"

            - stop

        # returns the balance from the db
        - case balance bal:
            # obtain player object
            - define query:<player>
            # helper command to look up other players
            - if <context.args.get[2].exists>:
                - if <player.has_permission[sigil.helper].if_null[<player.exists.not>]>:
                    # lookup fails, stop
                    - if !<server.match_offline_player[<context.args.get[2]>].exists>:
                        - narrate "<server.flag[sigiltag]> <&7>Error! Recipient <&e><context.args.get[2]> <&7>not found!"
                        - stop
                    # lookup success, pass player value
                    - define query:<server.match_offline_player[<context.args.get[2]>]>

            # do a sql lookup for the player, narrate the balance
            - ~run SigilDBQuery def:<[query]> save:balance
            - narrate "<server.flag[sigiltag]> <&7><[query].name>: <&e><entry[balance].created_queue.determination.get[1]><server.flag[SigilSym]>"

            - stop

        # transfers specified balance to another player via db
        - case send:
            # player lookup does not exist
            - if !<server.match_offline_player[<context.args.get[2]>].exists>:
                - narrate "<server.flag[sigiltag]> Error! Recipient <&e><context.args.get[2]> <&7>not found!"
                - stop
            - else:
                - define reciever:<server.match_offline_player[<context.args.get[2]>]>

            # player lookup does not match found player name
            - if !<[reciever].name.equals[<context.args.get[2]>]>:
                - narrate "<server.flag[sigiltag]> Error! Recipient <&e><context.args.get[2]> <&7>not found!"
                - stop

            # sigils sent is not an positive integer value
            - if !<context.args.get[3].is_integer.if_true[<context.args.get[3].is_more_than[0]>].if_false[False]>:
                - narrate "<server.flag[sigiltag]> Error! <&e><context.args.get[3]> Sigils <&7>is not a valid amount!"
                - stop

            - else:
                # vars for below script bcos I got lost
                - define amount:<context.args.get[3]>
                - define sender:<player>
                - define reciever:<[reciever]>

            # check to see if the sender has the balance
            - ~run SigilDBQuery def:<[sender]> save:sender
            - define sender_bal:<entry[sender].created_queue.determination.get[1]>
            - if !<[sender_bal].is_more_than_or_equal_to[<[amount]>]>:
                - narrate "<server.flag[sigiltag]> Error! You only have <&e><[sender_bal]><server.flag[SigilSym]> <&e>Sigils<&7>!"
                - stop

            # subtract the balance from the sender
            - ~run SigilDBSet def:<player>|<[sender_bal].sub[<[amount]>]>
            - narrate "<server.flag[sigiltag]> You have sent <&e><[amount]><server.flag[SigilSym]> to <[reciever].name>"

            # look up the other player's balance
            - ~run SigilDBQuery def:<[reciever]> save:reciever
            - define reciever_bal:<entry[reciever].created_queue.determination.get[1]>

            # add the new balance to the other player
            - ~run SigilDBSet def:<[reciever]>|<[reciever_bal].add[<[amount]>]>
            - narrate "<server.flag[sigiltag]> <player.name> has sent you <&e><[amount]><server.flag[SigilSym]>" targets:<[reciever]>

            - stop

        # queries db to view the top sigil balances
        - case top:
            #- ~sql id:sigildb "query:SELECT "
            - narrate 'here is the leaderboard'
            - debug top

            - stop

        - case default:
            - narrate "<server.flag[sigiltag]> Command not recognized!"
            - stop

        - case set take give:
            - define pass:pass

    ## Admin/Console Commands
    - if !<player.has_permission[sigil.admin].if_null[<context.source_type.equals[server]>]>:
        - narrate "<server.flag[sigiltag]> You do not have permission to do this!"
        - stop

    # check input to see if amount sent is a positive integer value
    - if !<context.args.get[3].is_integer.if_true[<context.args.get[3].is_more_than_or_equal_to[0]>].if_false[False]>:
        - narrate "<server.flag[sigiltag]> Error! <&e><context.args.get[3]> Sigils <&7>is not a valid amount!"
        - stop
    - else:
        - define amount:<context.args.get[3]>

    # check input to see if player is valid, define playertag with <[query]>
    - if !<context.args.get[2].exists>:
        - narrate "<server.flag[sigiltag]> Error! Recipient <&e><context.args.get[2]> <&7>not found!"
        - stop
    - else:
        - if !<server.match_offline_player[<context.args.get[2]>].exists>:
            - narrate "<server.flag[sigiltag]> Error! Recipient <&e><context.args.get[2]> <&7>not found!"
            - stop
        - else:
            - define query:<server.match_offline_player[<context.args.get[2]>]>
            - debug <[query]>

    - choose <context.args.first>:
        # Sets the balance of the player
        - case set:

            # set new balance
            - ~run SigilDBSet def:<[query]>|<[amount]>
            - narrate "<server.flag[sigiltag]> <&7><[query].name> new balance is: <&e><[amount]><server.flag[SigilSym]>"

            - stop

        # Removes balance from the player
        - case take:

            # look up the player's balance
            - ~run SigilDBQuery def:<[query]> save:take
            - define query_bal:<entry[take].created_queue.determination.get[1]>

            # subtract the relevant amount
            - define new_bal:<[query_bal].sub[<[amount]>]>
            - ~run SigilDBSet def:<[query]>|<[new_bal]>
            - narrate "<server.flag[sigiltag]> <&e><[amount]><server.flag[SigilSym]> has been removed, your new balance: <&e><[new_bal]><server.flag[SigilSym]>" targets:<[query]>

            - stop

        # Gives balance to the player
        - case give:

            # look up the player's balance
            - ~run SigilDBQuery def:<[query]> save:give
            - define query_bal:<entry[give].created_queue.determination.get[1]>

            # add the relevant amount
            - define new_bal:<[query_bal].add[<[amount]>]>
            - ~run SigilDBSet def:<[query]>|<[query_bal].add[<[amount]>]>
            - narrate "<server.flag[sigiltag]> You have recieved <&e><[amount]><server.flag[SigilSym]> your new balance: <&e><[new_bal]><server.flag[SigilSym]>" targets:<[query]>

            - stop