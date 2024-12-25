#this script is for the black market dude at spawn
xur:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
        - trigger name:click state:true
    interact scripts:
    - Xur_main

xur_main:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - cooldown 10s
                - random:
                    - narrate "<&8>{<&f>Black Marketeer<&8>} <&6>Xûr<&f>: My function here is to trade. I know this."
                    - narrate "<&8>{<&f>Black Marketeer<&8>} <&6>Xûr<&f>: I am filled with secrets, but you would not understand them."
                    - narrate "<&8>{<&f>Black Marketeer<&8>} <&6>Xûr<&f>: May we speak?"
                    - narrate "<&8>{<&f>Black Marketeer<&8>} <&6>Xûr<&f>: There is no reason to fear me."
                    - narrate "<&8>{<&f>Black Marketeer<&8>} <&6>Xûr<&f>: Do not be alarmed, I have no reason to cause you harm."