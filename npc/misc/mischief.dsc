mischief:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:10
    interact scripts:
    - my_interact

my_interact:
    type: interact
    steps:
        1:
            proximity trigger:
                entry:
                    script:
                    - if !<server.has_flag[checkToSchematicLoad]> && !<server.has_flag[endFixed]>:
                      - flag server checkToSchematicLoad duration:8m
                    - while <server.has_flag[checkToSchematicLoad]>:
                      - if <player.location.find_entities[ender_dragon].within[100].size>:
                        - worldedit paste file:FixEndHub position:fixendloc
                        - flag server checkToSchematicLoad:!
                        - flag server endFixed duration:5m
                      - wait 2m