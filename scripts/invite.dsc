## maintence
# to reset the invite list, run: /ex flag server inviteList:<list[]>

invite:
  type: command
  name: invite
  description: invite a sapling (friend) to HollowTree
  usage: /invite
  tab completions:
    1: view|create|accept|help
    2: <context.args.first.equals[accept].if_true[code].if_false[]>
  debug: true

  script:
    ## return the status of the panel
    - if <context.args.first> == view || <context.args.first.if_null[].equals[]>:
        - narrate "<&8>[<&a>🌲<&8>] <&2>HollowTree Invitations"
        # display the inviter
        - narrate " <&e>E<&color[#f1f150]>n<&color[#c9c942]>t<&7>: <player.flag[inviteEnt].if_null[/invite accept]>"
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

    ## creates an invite
    - if <context.args.first> == create:
        # defines the inviteList to be an empty list if it DNE
        - if !<server.flag[invitelist].exists>:
          - flag server inviteList:<list[]>

        # check to see if player already has an invite
        - define exists:False
        - foreach <server.flag[inviteList]> as:invite:
          - if <[invite].get[2].equals[<player>]>:
            - define code:<[invite]>
            - define exists:True

        # create an invitation code, add to the existing list of invites
        - if !<[exists]>:
          - define code:<list[<util.random_uuid.substring[32]>|<player>]>
          - define new_inviteList:<server.flag[inviteList]>
          - flag server inviteList:<[new_inviteList].include_single[<[code]>]>

        # tell the player what their invite code is
        - narrate "<&8>[<&a>🌲<&8>] <&f>Your invite code is: <&a><[code].get[1]> <&7>"

    ## accepts an invite
    - if <context.args.first> == accept:
        # search for the invitation code in the server flag
        - foreach <server.flag[inviteList]> as:invite:
            - if <[invite].conatins_match[<context.args.get[2]>]>:
              - narrate "<&8>[<&a>🌲<&8>] <&f>The code"

        # if the code is found:
          # set the player to be the sapling of the Ent
          # set the Ent to be the Ent of this player

        # else:
        - narrate "<&8>[<&a>🌲<&8>] <&f>The code <&c><context.args.get[2]> <&f>is invalid!"

        # run the vote rewarder for the first rank


    ## accepts an invite
    - if <context.args.first> == help:
      # return an explanation of each of the commands
      - narrate "<&8>[<&a>🌲<&8>] <&2>HollowTree Invitations"
      - narrate "/invite <&a>create <&f>to generate your invitation code"
      - narrate "/invite <&a>view <&f>to view your saplings(invited players)"
      - narrate "/invite <&a>accept <code><&f>to view your saplings(invited players)"



## checks to see if an invite exists
# return the invite listtag, li@code|<player>, else return null

## distributes the reward