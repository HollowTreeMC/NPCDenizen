testChatClickStart:
  type: task
  debug: false
  script:
  - clickable testChatClickable save:my_potato
  - clickable testChatClickable2 save:my_potato2
  - narrate "Hello <player.name>, please select your potato. <green><element[green].on_click[<entry[my_potato].command>]> <&r>| <dark_purple><element[purple].on_click[<entry[my_potato2].command>]>"

testChatClickable:
  type: task
  debug: false
  script:
  - flag player testscript:green
  - narrate "This is a potato you clicked <player.flag[testscript]>!"

testChatClickable2:
  type: task
  debug: false
  script:
  - flag player testscript2:purple
  - narrate "This is a potato you clicked <&color[#9d89ff]>test<player.flag[testscript2]>!"
  - wait 3s
  - ^random:
    - chat "<white>Wow, I'm a potato lord now."
    - chat <white>Yay!
    - chat "<white>Well, I never!"

