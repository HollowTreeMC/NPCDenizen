# This file contains the the scripts which handles the /invite commands

## Flags used in this file:
# <server.flag[inviteList]> is a ListTag of <list[<code|<playerTag>]> - to store generated invite codes and player objects
# <player.flag[inviteEnt]> is a <playerTag> - to store the player's Ents aka inviter
# <player.flag[inviteSaplings]> is a ListTag of <playerTag> - to store a player's invitees
# <player.flag[inviteRewards]> is a ListTag of string elements - to store a player's pending rewards

invite:
  type: command
  name: invite
  description: invite a sapling (friend) to HollowTree
  usage: /invite
  tab completions:
    1: list|create|accept|help|claim
    2: <context.args.first.equals[accept].if_true[code].if_false[]>
  debug: false

  script:
  - choose <context.args.first.if_null[list]>:

    # display a menu in chat including the player's invites and invitee
    - case list:
      - narrate "<server.flag[inviteTag]> <&2>HollowTree Invitations"
      # display the inviter
      - narrate " <&e>E<&color[#f1f150]>n<&color[#c9c942]>t<&7>: <player.flag[inviteEnt].name.if_null[/invite accept]>"
      # display the three invites a player can create, create the invites for them if they haven't already been created
      - narrate " <&color[#86c96e]>S<&color[#76bf5f]>a<&color[#66b550]>p<&color[#55ab41]>l<&color[#42a232]>i<&color[#2c9821]>n<&color[#068e0a]>g<&color[#068e0a]>s<&7>: (3)"
      # look through all the player's sapling tags
      - if !<player.has_flag[inviteSaplings]>:
        # player has no saplings
        - narrate "  <&7><&o>/invite create"
      - else:
        # list all saplings
        - foreach <player.flag[inviteSaplings]> as:Sapling:
          - narrate "  <&7><&o><[Sapling].name>"

    # creates an invite
    - case create:
      # defines the inviteList to be an empty list if it DNE
      - if !<server.flag[invitelist].exists>:
        - flag server inviteList:<list[]>
        ## rewrite this and the other 4 instances in this file of this with list insert <server.flag[]>:->:<Tag>

      # check to see if player already has an invite
      ## this should be a maptag
      - define exists:False
      - foreach <server.flag[inviteList]> as:invite:
        - if <[invite].get[2].equals[<player>]>:
          - define code:<[invite]>
          - define exists:True
          - foreach stop

      # create an invitation code, add to the existing list of invites
      - if !<[exists]>:
        - define code:<list[<util.random_uuid.substring[32]>|<player>]>
        - define new_inviteList:<server.flag[inviteList]>
        - flag server inviteList:<[new_inviteList].include_single[<[code]>]>

      # tell the player what their invite code is
      - narrate "<server.flag[inviteTag]> <&f>Your invite code is: <&a><[code].get[1]> <&7>"

    # accepts an invite
    - case accept:
      # check to see if the player has an ent
      - if !<player.flag[inviteEnt].is_empty>:
        - narrate "<server.flag[inviteTag]> <&f>You have already accepted an ent!"
        - stop
      # search for the invitation code in the server flag list
      - define exists:False
      - foreach <server.flag[inviteList]> as:invite:
          - if <[invite].get[1].equals[<context.args.get[2]>]>:
            # the existing invite is found
            - define exists:True
            - define ent:<[invite].get[2]>

            # if the ent has less than 3 saplings, add ent and sapling
            - if <[ent].flag[inviteSaplings].length.if_null[0]> < 3 && <player> != <[ent]>:
              # add the ent
              - flag <player> inviteEnt:<[ent]>
              # add the sapling
              - if !<[ent].flag[inviteSaplings].exists>:
                - flag <[ent]> inviteSaplings:<list[]>
              - define old_list:<[ent].flag[inviteSaplings]>
              - flag <[ent]> inviteSaplings:<[old_list].include_single[<player>]>
              # run the vote rewarder for the initial invite
              - narrate "<server.flag[inviteTag]> <&f>You have accepted <[ent].name>'s invitation! Here are the initial rewards!"
              - run invite_reward def:<player.uuid>|sapling
            - else:
              - narrate "<server.flag[inviteTag]> <&f><[ent].name> cannot accept you as a sapling!"

      # invite not in the server flag list
      - if !<[exists]>:
        - narrate "<server.flag[inviteTag]> <&f>The code <&c><context.args.get[2]> <&f>could not be found!"

    # runs reward script if player holds flags
    ## this could probably be further extended to notify players upon login
    - case claim:
      - if <player.flag[inviteRewards].exists>:
        - narrate "<server.flag[inviteTag]> <&f>Your rewards will be meted out!"
        - wait 2s
        - foreach <player.flag[inviteRewards]> as:milestone:
          - run invite_reward <player.uuid> <[milestone]>
          - flag <player> inviteRewards:!
      - else:
        - narrate "<server.flag[inviteTag]> <&f>You have no outstanding rewards"

    # displays the invitation commands and their usages
    - case help:
      # return an explanation of each of the commands
      - narrate "<server.flag[inviteTag]> <&2>HollowTree Invitations"
      - narrate "<&a>/invite create <&f>to generate your invitation code"
      - narrate "<&a>/invite view <&f>to view your saplings(invited players)"
      - narrate "<&a>/invite accept <&2>[code] <&f>to accept an invite"
      - narrate "<&a>/invite claim <&f>to claim outstanding rewards"

## reward distribution script
invite_reward:
  type: task
  definitions: playerUUID|milestone
  debug: false
  script:
    - define sapling:<player[<[playerUUID]>]>
    - define ent:<[sapling].flag[inviteEnt]>
    - foreach <[sapling]>|<[ent]> as:user:
      # check to see if the player is online
      - if <[user].is_online>:
        - narrate targets:<[user]> "<server.flag[inviteTag]> <&f>Rewards are being given for <[sapling].name> reaching <&a><[milestone]><&f>!"
        - if <[milestone]> == sapling:
          - execute as_server 'money give <[user].name> 1500 coins'
          - execute as_server 'acb <[user].name> 200'
          - execute as_server 'crates giveKey votinator <[user].name> 3'

        - if <[milestone]> == collector:
          - money give <[user]> 1500
          - execute as_server 'acb <[user].name> 200'
          - experience give 5 level player:<[user]>
          - execute as_server 'crates giveKey votinator <[user].name> 3'

        - if <[milestone]> == navigator:
          - money give <[user]> 6000
          - execute as_server 'acb <[user].name> 200'
          - experience give 10 level player:<[user]>
          - execute as_server 'crates giveKey votinator <[user].name> 3'

        - if <[milestone]> == renegade:
          - money give <[user]> 12000
          - experience give 15 level player:<[user]>
          - execute as_server 'crates giveKey votinator <[user].name> 3'

        - if <[milestone]> == gearsmith:
          - experience give 20 level player:<[user]>
          - execute as_server 'crates giveKey gearlord <[user].name> 1'

        - if <[milestone]> == watchmaker:
          - execute as_server 'crates giveKey gearlord <[user].name> 2'

        - if <[milestone]> == timekeeper:
          - execute as_server 'crates giveKey gearlord <[user].name> 3'

      - else:
        # store the rewards in a list for the player
        - if !<[user].flag[inviteRewards].exists>:
          - flag <[user]> inviteRewards:<list[]>
        - define list:<[user].flag[inviteRewards]>
        - flag <[user]> inviteRewards:<[list].include_single[<[milestone]>]>