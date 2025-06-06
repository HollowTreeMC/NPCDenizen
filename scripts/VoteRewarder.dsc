# This file contains the scripts relevant to the VotingPlugin & Vote Party Scripts

## Misc. Vote Functions, Check votes, Announces votes, Vote party announcer
# Sends a message to player upon login to notify additional rewards.
checkVotePending:
   type: world
   debug: false
   events:
     on player joins:
      - define countrewards 0
      - foreach <server.flag[rewardtype]>:
          - if <player.has_flag[<[value]>]>:
            - define countrewards:+:<player.flag[<[value]>]>
      - if <[countrewards]> > 0:
        - narrate "<server.flag[voteTag]> <gray><italic>You have unclaimed <[countrewards]> vote rewards. /vote claim or /vote manual to claim them."

# Sends a message in chat when a player has voted. Sends message displaying the player's all-time total number of votes
voteannounce:
  type: command
  description: narrate player vote
  name: voteannounce
  debug: false
  permission: developerLords.voteannounce
  usage: /voteannounce player
  Script:
    - announce "<server.flag[voteTag]> <gray><italic><context.args.get[1]> voted (<placeholder[votingplugin_alltimetotal].player[<server.match_player[<context.args.get[1]>]>]>)"

#Sends a message in Discord when the vote party is occuring
discordannounce:
  type: command
  description: narrate player vote
  name: discordannounce
  debug: false
  permission: developerLords.discordannounce
  usage: /discordannounce player
  Script:
    - execute as_server "discordsrv:discord bcast #1178874250891907142 ## Vote Party 🎉<&nl>*Rewards begin in 3 minutes! Be online to claim your prizes!*"

## Vote Party Script
# Announces the vote party, selects number of rewards, randomly chooses rewards from component scripts below
# Not meant to be triggerable, but instead run by the voting plugin
#could this be rewritten as a script not a command? to be /ex run VoteParty -Andrew
VoteRewardGiver:
  type: command
  description: Start random vote rewards
  name: VoteRewardGiver
  permission: developerLords.voterewardgiver
  debug: false
  usage: /VoteRewardGiver
  script:
      # Select the number of rewards, announce in chat
      - define numRewards <util.random.int[3].to[5]>
      - announce "<server.flag[voteTag]> Rolling for the number of rewards... <&b><magic>!<reset>🎲<&b><magic>!"
      - wait 2s
      - announce "<server.flag[voteTag]> <bold><[numRewards]> <&f> rewards to be given!"
      - wait 3s

      # Iterate through the rounds to select and distribute rewards
      - repeat <[numRewards]> as:i:

        # Is this flag necessary? I placed a long 30s pause in the loop instead of this check
        # - if <server.has_flag[pendingLoot]>:
        #   - wait 5s

        # Announce round & roll
        - if <[i]> < <[numRewards]>:
          - announce "<server.flag[voteTag]> Round <[i]> of <[numRewards]>! "
          - random:
            - announce "<server.flag[voteTag]> Rolling a dice to see what we get! <&b><magic>!<reset>🎲<&b><magic>!"
            - announce "<server.flag[voteTag]> Are you feeling lucky? Let's roll, <&b><magic>!<reset>🎲<&b><magic>!"
            - announce "<server.flag[voteTag]> So many outcomes... Here's the roll, <&b><magic>!<reset>🎲<&b><magic>!"
            - announce "<server.flag[voteTag]> Blargh, you're no fun. Let's roll! <&b><magic>!<reset>🎲<&b><magic>!"

        # Announce last round & roll
        - else:
          - announce "<server.flag[voteTag]> And now, for the final round... <&b><magic>!<reset>🎲<&b><magic>!"
          - wait 4s
          - random:
            - announce "<server.flag[voteTag]> I can't look! Oh man what is it?"
            - announce "<server.flag[voteTag]> I bet the suspense is killing you...CREEPER!"
            - announce "<server.flag[voteTag]> How much wood could a wood chuck chuck?"
            - announce "<server.flag[voteTag]> I'm feeling lucky..."

        # Queue component script
        - random:
          - run VoteRewardCoins
          - run VoteRewardExp
          - run VoteRewardClaim
          - run VoteRewardSpiller

        - wait 30s

## Components to the Vote Party Script
# Rewards the player with coins, ranging from 100 to 1500 coins
VoteRewardCoins:
    type: task
    debug: false
    script:
      # Rolls the amount
      - define amount <util.random.int[100].to[1500]>
      # Announces the reward
      - random:
        - announce "<server.flag[voteTag]> &a&lCoins!&r Show em' the coinnns!"
        - announce "<server.flag[voteTag]> &a&lCoins!&r Lets see how much cash you get this time..."
        - announce "<server.flag[voteTag]> &a&lCoins!&r Ooo coins."
        - announce "<server.flag[voteTag]> &a&lCoins!&r Lets see those monies"
      # Distributes the reward
      - random:
          - foreach <server.online_players>:
            - execute as_server 'money give <[value].name> <[amount]> coins'

# Rewards the player with exp, ranging from 2 to 15 levels
VoteRewardExp:
    type: task
    debug: false
    script:
      # Rolls the amount
      - define amount <util.random.int[2].to[15]>
      # Announces the reward
      - random:
        - announce "<server.flag[voteTag]> &d&lEXP!&r Exps for the peeps!"
        - announce "<server.flag[voteTag]> &d&lEXP!&r Exp finally working? Someone needs to fire the boss."
        - announce "<server.flag[voteTag]> &d&lEXP!&r Exp for thee."
        - announce "<server.flag[voteTag]> &d&lEXP!&r Oh good exp finally works."
      # Distributes the reward
      - foreach <server.online_players>:
          - experience give <[amount]> level player:<[value]>
          - narrate "<server.flag[voteTag]> You got <[amount]> levels!" target:<[value]>

# Rewards the player with claim blocks, ranging from 25 to 300
VoteRewardClaim:
    type: task
    debug: false
    script:
      # Rolls the amount
      - define amount <util.random.int[25].to[300]>
      # Announces the reward
      - random:
        - announce "<server.flag[voteTag]> &a&lClaimblocks!&r Lets go claim blocks!"
        - announce "<server.flag[voteTag]> &a&lClaimblocks!&r Claimin' the blocks!"
        - announce "<server.flag[voteTag]> &a&lClaimblocks!&r Block claiming randomizer power on..."
      # Distributes the reward
      - foreach <server.online_players>:
        - execute as_server 'acb <[value].name> <[amount]>'
        - narrate "<server.flag[voteTag]> You have received <[amount]> claim blocks!" target:<[value]>

# Rewards the player with phatloots, spiller vote and spiller daily
VoteRewardSpiller:
    type: task
    debug: false
    script:
      # Announces the reward
      - random:
        - announce "<server.flag[voteTag]> {#5c8be6}&lLoot Rewards!&r Random goodies!"
        - announce "<server.flag[voteTag]> {#5c8be6}&lLoot Rewards!&r Oooo spill those rewards out for me!"
        - announce "<server.flag[voteTag]> {#5c8be6}&lLoot Rewards!&r LOOT!! I Loaf Loot. Good luck on your bread head."
      # Distributes the reward
      - random:
        - execute as_server 'Spiller Vote'
        - execute as_server 'Spiller Daily'


## Vote reward command & spiller script
# Allows players to claim vote rewards when they otherwise were not able to
votereward:
   type: command
   description: Start or stop vote rewards!
   name: votereward
   permission: vote.toggle
   debug: false
   usage: /votereward pause claim manual
   tab completions:
        1: pause|claim|check|manual
   script:
      - define tag <server.flag[voteTag]>
      - define sub <context.args.get[1]>
      - choose <[sub]>:
        - case pause:
          - flag player commandVoteInUse
          - if !<player.has_flag[rewardPaused]>:
            - flag player rewardPaused
            - narrate "<[tag]> You have disabled automatic redemption of voting rewards!"
            - wait 2s
            - narrate "<[tag]> Use <green>/votereward <reset>pause to toggle automation on."
            - flag player commandVoteInUse:!
            - stop
          - flag player rewardPaused:!
          - flag player commandVoteInUse:!
        - case claim:
            - flag player commandVoteInUse
            - foreach <server.flag[rewardtype]>:
              - if <player.flag[<[value]>]> > 0:
                - define countrewards:+:<player.flag[<[value]>]>
            - if <[countrewards]> > 0:
              - narrate "<[tag]> You are about to redeem <[countrewards]> different rounds of rewards! Get ready!"
              - wait 2s
              - foreach <server.flag[rewardtype]>:
                - if <player.has_flag[<[value]>]>:
                  - while <player.flag[<[value]>]> > 0:
                    - execute as_server "loot spill <[value].to_sentence_case> <player.location.x.round> <player.location.y.round> <player.location.z.round> <player.world.name>"
                    - flag player <[value]>:--
                    - wait 3s
              - narrate "<[tag]> All rewards have been given!"
              - flag player commandVoteInUse:!
              - stop
            - narrate "<[tag]> You have no rewards to redeem!"
            - flag player commandVoteInUse:!
        - case check:
            - define countrewards 0
            - flag player commandVoteInUse
            - foreach <server.flag[rewardtype]>:
              - if <player.flag[<[value]>]> > 0:
                - define countrewards:+:<player.flag[<[value]>]>
            - if <[countrewards]>:
              - if <[countrewards]> > 0:
                - narrate "<[tag]> You have <[countrewards]> to redeem!"
                - wait 2s
                - narrate "<[tag]> Use <green>/votereward claim <reset>to to start your individual vote party."
                - wait 3s
                - narrate "<[tag]> <bold>Don't want to party? <reset>Get them one by one with <green>/votereward manual<reset>!"
                - stop
            - narrate "<[tag]> You have no rewards to redeem at this time."
            - flag player commandVoteInUse:!
        - case manual:
            - flag player commandVoteInUse
            - foreach <server.flag[rewardtype]>:
              - if <player.flag[<[value]>]> > 0:
                - define countrewards:+:<player.flag[<[value]>]>
            - if <[countrewards]> > 0:
              - foreach <server.flag[rewardtype]>:
                - narrate <[value]>
                - if <player.flag[<[value]>]> > 0:
                    - execute as_server "loot give <player.name> <[value].to_sentence_case>"
                    - flag player <[value]>:--
                    - if <[countrewards].sub[1]> < 1:
                      - wait 3s
                      - narrate "<[tag]> All rewards have been given!"
                      - flag player commandVoteInUse:!
                      - stop
                    - if <[countrewards].sub[1]> > 0:
                      - wait 1s
                      - narrate "<[tag]> You have <[countrewards].sub[1]> more to redeem."
                      - flag player commandVoteInUse:!
                      - stop
            - narrate "<[tag]> You have no rewards to redeem!"
            - flag player commandVoteInUse:!

# Handles disbersement of rewards via phatloots
Spiller:
  type: command
  description: Spill a phatloot for a player
  name: Spiller
  permission: developerLords.spiller
  debug: false
  usage: /Spiller phatloot
  tab completions:
      1: <server.flag[rewardtype]>
  script:
    - define loot <context.args.get[1]>
    - define tag <server.flag[voteTag]>
    - flag server pendingLoot
    - if <[loot]> == Vote || <[loot]> == Daily:
      - wait 2s
      - foreach <server.online_players>:
        - if <[value].has_flag[rewardPaused]>:
          - if <[value].flag[<[loot]>]> > 13:
            - narrate "<[tag]> unfortunately you were unable to store any more vote redemptions in your queue. Vote reward was lost." targets:<[value]>
          - if <[value].flag[<[loot]>]> > 9:
            - narrate "<[tag]> the <red>10th<reset> reward was added to your queue, only <red>15 <reset>can be stored at a time." targets:<[value]>
            - wait 3s
            - flag <[value]> <[loot]>:++
            - narrate "<[tag]> Be sure to <green>/votereward claim <reset>to start claiming your vote rewards!" targets:<[value]>
          - if <[value].flag[<[loot]>]> < 9:
            - flag <[value]> <[loot]>:++
            - narrate "<gray><italic>1 loot was added to your queue, only 15 can be stored at a time." targets:<[value]>
        - if !<[value].has_flag[rewardPaused]>:
          - execute as_server "loot spill <[loot]> <[value].location.x.round> <[value].location.y.round> <[value].location.z.round> <[value].world.name>"
          - if !<[value].has_flag[notifyToggle]>:
            - narrate "<[tag]> You can use <green>/votereward pause <reset>to manually redeem vote rewards, you can redeem those rewards by:" targets:<[value]>
            - wait 2s
            - narrate "<[tag]> <green>/votereward manual<reset> to manually get each reward set." targets:<[value]>
            - wait 2s
            - narrate "<[tag]> Or <green>/votereward claim <reset>which claims all rewards in bursts when you are ready!" targets:<[value]>
            - flag <[value]> notifyToggle expire:30m
    - narrate "<[tag]> Loot was given for all players! (if it failed, check the caps on your command.)"
    - flag server pendingLoot:!