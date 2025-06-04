# Sends a message to players upon login to notify additional rewards.
checkVotePending:
   type: world
   debug: false
   events:
     on player joins:
      - define tag <dark_aqua>[<aqua>!<dark_aqua>]<white>
      - define countrewards 0
      - foreach <server.flag[rewardtype]>:
          - if <player.has_flag[<[value]>]>:
            - define countrewards:+:<player.flag[<[value]>]>
      - if <[countrewards]> > 0:
        - narrate "<[tag]> <gray><italic>You have unclaimed <[countrewards]> vote rewards. /vote claim or /vote manual to claim them."

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
      - define tag <dark_aqua>[<aqua>!<dark_aqua>]<white>
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
    - define tag <dark_aqua>[<aqua>!<dark_aqua>]<white>
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

#Vote Party Script, not meant to be triggerable, but instead run by the voting plugin
#could this be rewritten as a script not a command? to be /ex run VoteParty -Andrew
VoteRewardGiver:
  type: command
  description: Start random vote rewards
  name: VoteRewardGiver
  permission: developerLords.voterewardgiver
  debug: false
  usage: /VoteRewardGiver
  script:
      - define amountRewards <util.random.int[3].to[5]>
      - announce "<server.flag[voteTag]> Determining vote reward amount...."
      - wait 3s
      - announce "<server.flag[voteTag]> Server has decided on...."
      - wait 3s
      - announce "<server.flag[voteTag]> <bold><[amountrewards]> Vote Rewards to give!"
      - wait 4s
      - flag server count:0
      - flag server countDown:<[amountRewards]>
      - announce "<server.flag[voteTag]> <&9>🎲 🎲 &fRolling a dice to see what we get.<&9> 🎲 🎲"
      - wait 4s
      - while <server.flag[count]> < <[amountRewards]>:
        - if !<server.has_flag[pendingLoot]>:
          - flag server count:++
          - flag server countDown:--
          - random:
            - run spillerRun
            - run spillerRun
            - run spillerRun
            - run moneyRun
            - run moneyRun
            - run moneyRun
            - run claimblockclaim
            - run experienceRun
          - wait 6s
          - if <server.flag[countDown]> > 2:
            - announce "<server.flag[voteTag]> <bold><server.flag[countDown]> Rounds To Go!"
            - wait 1s
            - announce "<server.flag[voteTag]> <&9>🎲 🎲 &fRolling....<&9> 🎲 🎲"
          - if <server.flag[countDown]> == 1:
            - announce "<server.flag[voteTag]> <bold><server.flag[countDown]> Last Round!!!!"
            - wait 3s
            - announce "<server.flag[voteTag]> <&9>🎲 🎲 &fFinal Roll....<&9> 🎲 🎲"
          - if <server.flag[countdown]> < 1:
            - stop
        - wait 5s

moneyRun:
    type: task
    debug: false
    script:
      - random:
        - announce "<server.flag[voteTag]> &a&lMoney!&r Show em' the mooneyy!"
        - announce "<server.flag[voteTag]> &a&lMoney!&r Lets see how much cash you get this time..."
        - announce "<server.flag[voteTag]> &a&lMoney!&r Ooo coins."
        - announce "<server.flag[voteTag]> &a&lMoney!&r Lets see those monies"
        - announce "<server.flag[voteTag]> &a&lMoney!&r Caching!"
      - random:
          - foreach <server.online_players>:
            - random:
              - execute as_server 'money give <[value].name> <util.random.int[50].to[250]> coins'
              - execute as_server 'money give <[value].name> <util.random.int[100].to[400]> coins'
              - execute as_server 'money give <[value].name> <util.random.int[10].to[1000]> coins'
          - foreach <server.online_players>:
            - random:
              - execute as_server 'money give <[value].name> <util.random.int[250].to[1000]> coins'
              - execute as_server 'money give <[value].name> <util.random.int[50].to[2000]> coins'
experienceRun:
    type: task
    debug: false
    script:
      - define tag <dark_aqua>[<aqua>!<dark_aqua>]<white>
      - random:
<<<<<<< Updated upstream
        - execute as_server "broadcast &d&lEXP!&r Exps for the peeps!"
        - execute as_server "broadcast &d&lEXP!&r Just some experience. Better luck next roll."
        - execute as_server "broadcast &d&lEXP!&r Exp for thee."
=======
        - announce "<server.flag[voteTag]> &d&lEXP!&r Exps for the peeps!"
        - announce "<server.flag[voteTag]> &d&lEXP!&r Exp finally working? Someone needs to fire the boss."
        - announce "<server.flag[voteTag]> &d&lEXP!&r Exp for thee."
        - announce "<server.flag[voteTag]> &d&lEXP!&r Oh good exp finally works."
>>>>>>> Stashed changes
      - foreach <server.online_players>:
          - define amount <util.random.int[2].to[15]>
          - experience give <[amount]> player:<[value]>
          - narrate "<[tag]> You got <[amount]> experience levels!" target:<[value]>
claimBlockClaim:
    type: task
    debug: false
    script:
      - define tag <dark_aqua>[<aqua>!<dark_aqua>]<white>
      - random:
        - announce "<server.flag[voteTag]> &a&lClaimblocks!&r Lets go claim blocks!"
        - announce "<server.flag[voteTag]> &a&lClaimblocks!&r Claimin' the blocks!"
        - announce "<server.flag[voteTag]> &a&lClaimblocks!&r Block claiming randomizer power on..."
      - foreach <server.online_players>:
        - define amount <util.random.int[25].to[300]>
        - execute as_server 'acb <[value].name> <[amount]>'
        - narrate "<[tag]> You have received <[amount]> claim blocks!" target:<[value]>
spillerRun:
    type: task
    debug: false
    script:
      - random:
        - announce "<server.flag[voteTag]> {#5c8be6}&lLoot Rewards!&r Random goodies!"
        - announce "<server.flag[voteTag]> {#5c8be6}&lLoot Rewards!&r Oooo spill those rewards out for me!"
        - announce "<server.flag[voteTag]> {#5c8be6}&lLoot Rewards!&r LOOT!! I Loaf Loot. Good luck on your bread head."
      - random:
        - execute as_server 'Spiller Vote'
        - execute as_server 'Spiller Daily'

#Send a message when a player has voted. Sends message displaying the player's all-time total number of votes
voteannounce:
  type: command
  description: narrate player vote
  name: voteannounce
  debug: false
  permission: developerLords.voteannounce
  usage: /voteannounce player
  Script:
    - announce "<gray><italic><context.args.get[1]> voted! (<placeholder[votingplugin_alltimetotal].player[<server.match_player[<context.args.get[1]>]>]>)"

#Send a message in Discord when the vote party is occuring
discordannounce:
  type: command
  description: narrate player vote
  name: discordannounce
  debug: false
  permission: developerLords.discordannounce
  usage: /discordannounce player
  Script:
    - execute as_server "discordsrv:discord bcast #496872659125010452 🪅 Vote Party! 🪅<&nl>～~～~～~～~～~～~～~～~～~～~～~～~～~～~<&nl>💰 ✨ 💰  Good Luck! 💰 ✨ 💰<&nl>～~～~～~～~～~～~～~～~～~～~～~～~～~～~<&nl>Starting in 3 minutes<&nl>@Keys"