Balance:
  type: command
  description: Check player balance and number of Sigils
  name: Balance
  debug: false
  usage: /balance
  script:
    - narrate "<&e>Balance: <&6><placeholder[cmi_user_balance_formatted]> <&e>Sigils: <&6>⚙<placeholder[tne_currency_Sigils]>"