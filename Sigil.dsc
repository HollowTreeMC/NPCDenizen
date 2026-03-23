## HollowCraft Sigil Economy Script
# This script is a local economy system which loads data from a global source (database) upon player joins / quits. The primary function of Sigils are to be used in other Denizen scripts, so they do not need to emulate an actual economy.

## Flags used in this file
# <player.flag[Sigils]> is an int - returns the number of sigils the player has

#TODO:
#Implement initial setup for db table - UUID, Balance
#Implement commands for players and plugins to run
#Implement automatic database saves / dumps on server start
#Implement scheduled automatic updating of online players server flag

Sigildb:
    type: world
    debug: false
    events:
        on server start:
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

        # send message to console, DB connection not established!
        on script generates error:
        - debug error "Error occured in Sigil script! Please check the credentials in plugins/Denizen/SigilDB.yml Line: <context.line>, <context.message>"
        - stop

Sigilcmd:
    type: command
    debug: false
    description: Sigil Commands
    name: sigil
    usage: /sigil [command]
    tab completions:
        1: help|balance|send|top<player.has_permission[sigil.admin].if_true[|set|take|give].if_false[]>
    script:
    - choose <context.args.first>:
        # returns the number of points from the Points Maptag
        - case help: