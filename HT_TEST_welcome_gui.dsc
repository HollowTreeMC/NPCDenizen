#+----------------------
#|
#| W e l c o m e  GUI System
#|
#| Create beautiful multi-page welcome messages for your server!
#|
#+----------------------
#
#@author ArZer0
#@script-version 1.0
#
#Installation:
#Simply place the script in your scripts folder and reload Denizen.
#
#Usage:
#The welcome GUI automatically shows to new players when they join the server.
#You can also manually trigger it with the command:
#- /welcome_gui open welcome [player_name] - Show welcome GUI to yourself or specified player
#
#Configuration:
#Edit the data_welcome_gui script to customize:
#- Text content on each page
#- Icons and background colors
#- You can create multiple GUI types by adding new entries in the data section
#
#Requirements:
#- Resource pack with welcome_guis and space fonts
#
#---------------------------- END HEADER ----------------------------

test_text_gui:
    type: task
    debug: false
    definitions: id
    script:
    - flag <player> page:1
    - flag <player> pages:<script[data_welcome_gui].data_key[data.id.<[id]>.text].keys.size>
    - flag <player> type:<[id]>
    - adjust <player> item_slot:5
    - inventory open d:welcome_text_gui

welcome_text_gui:
    type: inventory
    debug: false
    inventory: chest
    gui: true
    size: 54
    title: "<proc[welcome_text_generation].context[<player.flag[type]||mine>]>"

data_welcome_gui:
    type: data
    data:
      id:
        welcome:
          text:
            1:
            - "<&color[#baff99]>Once upon a time, a beautiful, wise mother owl"
            - "dropped a seed from the hollow of her tree"
            - "in a majestic land called HollowTree."
            - "That seedling took time to germinate, but once it did,"
            - "it sprouted into a strong sapling! 🌱"
            - " "
            - "<&f>Welcome to <&3>Hollowtree<&f>!"
            - " "
            - "<&b>Click <&e>NEXT<&r><&b> to continue..."
            2:
            - "<&d>Server Rules:"
            - "1. <&a>No Disrespect"
            - "2. <&a>No Offensive Subjects"
            - "3. <&a>No Advertising"
            - "4. <&a>No Swearing"
            - "5. <&a>No Griefing, Raiding, Stealing, or Traps"
            - "6. <&a>No Cheating"
            - " "
            - "<&b>Click <&e>NEXT<&b> to continue..."
            3:
            - "<&d>Server Rules:"
            - "7. <&a>No Spamming"
            - "8. <&a>English in Main Chat"
            - "9. <&a>No Begging"
            - "10. <&a>No Lag Machines"
            - "11. <&a>No Building Near Others"
            - "12. <&a>No Drama!"
            - "<&2>Tip: Check /rules for more info! "
            - " "
            - "<&b>Click <&e>NEXT<&b> to continue..."
            4:
            - "<&6>Server Commands:"
            - "<&f>/spawn <&7>- return to spawn"
            - "<&f>/tpa [playername] <&7>- teleport to a player"
            - "<&f>/home <&7>- to view your list of homes"
            - "<&f>/sethome [name] <&7>- create a new home"
            - "<&f>/msg <&7>- send a private message <&f>(Also '/r' to reply!)"
            - "<&f>/shop <&7>- open the server shop"
            - "<&7>/help <&2>for more!"
            - "<&b>Click <&e>NEXT<&b> to continue..."
            5:
            - "<&2>Our Contacts:"
            - "<&f>Discord: <&9>discord.gg/cwbfvDSQah"
            - "<&f>Wiki: <&9>https://wiki.hollowcraft.net"
            - "<&f>Socials: <&9>n/a"
            - "<&d>If you have any questions or suggestions,"
            - "<&d>please contact the server moderation team."
            - "<&b>Have fun! We're happy to have you<&f>!"
          ico: e003
          ico_background: 'e002'
          color_background: '&x&2&f&2&f&2&f'



welcome_fake_update_inventory:
    type: task
    debug: false
    script:
    - repeat 36:
        - if <[value].equals[1]> || <[value].equals[9]> || <[value].equals[7]>:
            - repeat next
        - fakeitem air slot:<[value]> duration:1d players:<player>
    - if <player.flag[page]||1> > 1:
        - fakeitem right_arrow_button slot:1 duration:1d players:<player>
    - else:
        - fakeitem air slot:1 duration:1d players:<player>
    - if <player.flag[pages]||1> > <player.flag[page]||1>:
        - fakeitem left_arrow_button slot:9 duration:1d players:<player>
    - else:
        - fakeitem air slot:9 duration:1d players:<player>
    - if <player.has_flag[show_welcome_gui]>:
        - fakeitem cancel_button slot:7 duration:1d players:<player>
    - else:
        - fakeitem accept_button slot:7 duration:1d players:<player>


right_arrow_button:
    type: item
    debug: false
    material: structure_void
    display name: "<&f><&l>Previous page"
    mechanisms:
        custom_model_data: 1

left_arrow_button:
    type: item
    debug: false
    material: structure_void
    display name: "<&f><&l>Next page"
    mechanisms:
        custom_model_data: 2

cancel_button:
    type: item
    debug: false
    material: structure_void
    display name: "<&f><&l>Do not show again"
    mechanisms:
        custom_model_data: 3

accept_button:
    type: item
    debug: false
    material: structure_void
    display name: "<&f><&l>Show again"
    mechanisms:
        custom_model_data: 4


welcome_text_generation:
    type: procedure
    debug: false
    definitions: id
    script:
    - define text <proc[space].context[-1500]>
    - define color_background <script[data_welcome_gui].data_key[data.id.<[id]>.color_background].parse_color||<&0>>
    - define background_gui <&chr[<script[data_welcome_gui].data_key[data.id.<[id]>.ico]||e003>].font[welcome_guis:welcome_guis]>
    - define background_gui_ico <&chr[<script[data_welcome_gui].data_key[data.id.<[id]>.ico_background]||e001>].font[welcome_guis:welcome_guis]>
    - define text <[text]><[color_background]><[background_gui_ico]><proc[space].context[-1548]><&f><[background_gui]><proc[space].context[-252]>
    - define output_value <empty>
    - define page <player.flag[page]||1>
    - repeat 9:
        - define line <script[data_welcome_gui].data_key[data.id.<[id]>.text].get[<[page]>].get[<[value]>].parsed||<empty>>
        - define output_value <[output_value]><proc[text_line_generate].context[<[value]>|<[line]>]>
    - determine <[text]><[output_value]>

text_width_check:
  type: procedure
  debug: false
  definitions: message|del
  script:
  - define del <[del]||1>
  - define bukvi <[message].strip_color>
  - define bukviup QWERTYUIOPASDFGHJKLZXCVBNMЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ
  - define coef 1
  - define sum 0
  - repeat <[bukvi].length>:
    - if <[bukviup].contains_case_sensitive_text[<[bukvi].char_at[<[value]>]>]>:
      - define textSymbols <map[Г=6;Д=7;Ц=7;Ш=8;Щ=9;Ъ=7;Ы=8;Ж=8;Ю=8;Ф=8]>
    - else:
      - define textSymbols <map[г=5;д=7;к=5;щ=7;ы=7;ъ=7;ю=8]>
    - define num <[textSymbols].get[<[bukvi].char_at[<[value]>]>]||<[bukvi].char_at[<[value]>].text_width>>
    - define sum:+:<[num]>
  - determine <[sum].div[<[del]>].round>

text_line_generate:
    type: procedure
    debug: false
    definitions: size|text_input
    script:
    - determine <empty> if:<element[<[text_input]||null>].equals[null]>
    - determine <[text_input].font[welcome_guis:dialogues/size<[size]>]><proc[space].context[-<proc[text_width_check].context[<[text_input]>]>]>

space:
    type: procedure
    debug: false
    definitions: count
    script:
        - if <[count]||null> == null:
            - determine <empty>
        - define whole_part <[count].round_down>
        - define result <&translate[key=space.<[whole_part]>].font[space:space]>
        - define fraction <[count].sub[<[whole_part]>]>
        - if <[fraction]> != 0:
            - define quarters <[fraction].abs.mul[4].round>
            - if <[quarters]> > 0:
                - define quarter_key  <tern[<[count].is_more_than_or_equal_to[0]>].pass[space.1/4].fail[space.-1/4]>
                - define result <[result]><&translate[key=<[quarter_key]>].font[space:space].repeat[<[quarters]>]>
        - determine <[result]>

ivoxopen_cmd:
    type: command
    name: welcome_gui
    description: Does something
    usage: /welcome_gui <&lt>arg<&gt>
    permission: dscript.welcome_gui
    tab completions:
        1: open
        2: <script[data_welcome_gui].data_key[data.id].keys>
        3: name
    script:
    - if <context.args.get[1]||null> == open:
        - define id <context.args.get[2]||null>
        - if <[id]||null> != null:
            - define player_name <context.args.get[3]||null>
            - if <[player_name]||null> != null:
                - run test_text_gui def:<[id]> player:<server.match_player[<[player_name]>]>
            - else:
                - run test_text_gui def:<[id]>
        - else:
            - narrate "<&c>enter id"
    - else:
        - narrate "<&c>use /welcome_gui open id player_name"


welcome_world_gui:
    type: world
    debug: false
    events:
        after player joins:
        - waituntil <player.ping.equals[0].not||false> max:5s
        - if <player.is_online> && <player.has_flag[show_welcome_gui].not>:
            - run test_text_gui def:welcome
        after player opens welcome_text_gui:
        - run welcome_fake_update_inventory
        after player closes welcome_text_gui:
        - inventory update
        on player drags in welcome_text_gui:
        - determine passively cancelled
        - run welcome_fake_update_inventory
        on player clicks in welcome_text_gui bukkit_priority:lowest:
        - determine passively cancelled
        - ratelimit <player> 5t
        - run welcome_fake_update_inventory
        - if <context.clicked_inventory.id_holder.equals[<player>]||false>:
            - if <context.slot> == 1:
                - if <player.flag[page]||1> > 1:
                    - flag <player> page:<player.flag[page].sub[1].max[1]||1>
                    - inventory open d:welcome_text_gui
            - if <context.slot> == 9:
                - if <player.flag[pages]||1> > <player.flag[page]||1>:
                    - flag <player> page:<player.flag[page].add[1]||1>
                    - inventory open d:welcome_text_gui
            - if <context.slot> == 7:
                - if <player.has_flag[show_welcome_gui]>:
                    - flag <player> show_welcome_gui:!
                - else:
                    - flag <player> show_welcome_gui:true
                - inventory open d:welcome_text_gui