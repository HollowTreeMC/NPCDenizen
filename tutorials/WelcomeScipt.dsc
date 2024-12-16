KirraNPC:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true radius:5
    interact scripts:
    - Welcome

Welcome:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - flag player rulesRead:!
                - engage
                - ratelimit <player> 10s
                - clickable newPlayerRules save:rules
                - define kirraTag "[<&3>Ki<&b>rr<&f>a]:"
                - narrate "<[kirraTag]> Hello <player.name>! Welcome to Hollowtree, a non-grief server. Please read our <aqua>[<blue><element[rules].on_click[<entry[rules].command>]><aqua>]<reset>!"
                - wait 3
                - narrate "<[kirraTag]> <&color[#ccfffc]>Click me again once you've finished!"
                - wait 2
                - disengage
                - zap 2
        2:
            click trigger:
                script:
                - engage
                - clickable newPlayerRules save:rules
                - clickable TeleportSpawn save:spawn
                - clickable TeleportWilds save:wilds
                - define kirraTag "[<&3>Ki<&b>rr<&f>a]:"
                - if <player.has_flag[rulesRead]>:
                  - narrate "<[kirraTag]> Thank you for reading our rules!"
                  - wait 2
                  - narrate "<[kirraTag]> <&color[#ccfffc]>You can stay and learn more by clicking me again, or I can teleport you to <aqua>[<blue><element[Spawn].on_click[<entry[spawn].command>]><aqua>]<&color[#e6fff4]> or the <aqua>[<green><element[Wilds].on_click[<entry[wilds].command>]><aqua>]<reset>."
                  - zap 3
                  - disengage
                - else:
                  - narrate "<[kirraTag]> Please click to view our <aqua>[<blue><element[rules].on_click[<entry[rules].command>]><aqua>]<reset> to continue on your journey!"
                  - disengage
        3:
            click trigger:
                script:
                - engage
                - clickable MoreSave save:more
                - clickable TeleportSpawn save:spawn
                - define kirraTag "[<&3>Ki<&b>rr<&f>a]:"
                - narrate "<[kirraTag]> Here's a few more things you may want to know about our server."
                - wait 3
                - narrate "<[kirraTag]> <&color[#ccfffc]>You can /sethome (name) to set a home warp!"
                - wait 3
                - narrate "<[kirraTag]> This will be your safe zone that you should claim with a golden shovel, found in your inventory."
                - wait 4
                - narrate "<[kirraTag]> <&color[#ccfffc]>You can return home anytime by using the command /home (name)."
                - wait 3
                - narrate "<[kirraTag]> Would you like to learn more or would you like me to teleport you to spawn? <aqua>[<blue><element[Spawn].on_click[<entry[spawn].command>]><aqua>] <aqua>[<dark_purple><element[More].on_click[<entry[more].command>]><aqua>]<reset>"
                - disengage
                - zap 4
        4:
            click trigger:
                script:
                - define kirraTag "[<&3>Ki<&b>rr<&f>a]:"
                - clickable TeleportSpawn save:spawn
                - clickable TeleportWilds save:wilds
                - narrate "<[kirraTag]> Sorry, that's it at this time would you like me to teleport you to spawn? <aqua>[<blue><element[Spawn].on_click[<entry[spawn].command>]><aqua>]"
newPlayerRules:
  type: task
  debug: false
  script:
  - execute as_player rules
  - flag player rulesRead
  - execute as_server "lp user <player.name> parent add default"
  - wait 15
  - narrate "<&b>[<&3>!<&b>]<reset> You have read the rules of Hollowtree and have been granted your rank! Rankup guides are found at spawn and personal detailed information found by using /rankinfo"
MoreSave:
  type: task
  debug: false
  script:
    - zap <player> step:4 script:Welcome
    - run endMore

TeleportSpawn:
  type: task
  debug: false
  script:
      - execute as_server "spawn <player.name>"
TeleportWilds:
  type: task
  debug: false
  script:
    - if !<player.has_flag[welcomed]>:
      - execute as_server "rtp <player.name> Hollowtree"
      - flag player welcomed

endMore:
  type: task
  debug: false
  script:
    - clickable TeleportOut save:teleport
    - define kirraTag "[<&3>Ki<&b>rr<&f>a]:"
    - narrate "<[kirraTag]> Sorry, that's it at this time would you like me to teleport you to spawn? <aqua>[<blue><element[Teleport].on_click[<entry[teleport].command>]><aqua>]"
