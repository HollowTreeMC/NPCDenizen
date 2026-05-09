Balance:
  type: command
  description: Check player balance and number of Sigils
  name: Balance
  debug: false
  usage: /balance
  script:
    - narrate "<&6>Balance: <&e><placeholder[cmi_user_balance_formatted]><&sp> <&6>Sigils: <&e><player.flag[Sigils]><&l>ღ"