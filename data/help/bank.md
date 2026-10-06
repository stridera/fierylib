---
keywords: [bank, banking, atm, deposit, withdraw, balance, bal]
title: The Bank
category: guide
min_level: 0
usage: "balance | deposit {copper} | withdraw {copper} | exchange {amount} {from} {to}"
---
The bank keeps your coin separate from the coin you carry. Bankers are
NPCs found in town banks.

  balance          (or bal) show your bank balance and the coin you carry.
                   Works anywhere.
  wealth           show only the coin you carry.
  deposit 1000     move 1000 copper from your pocket into the bank.
  withdraw 500     take 500 copper back out.

  deposit and withdraw need a banker in the room, and the amount is a
  whole number of copper pieces: 1000 copper is 1 platinum, so
  "deposit 1000" banks one platinum. (Writing "deposit 400 copper" is
  not understood; just give the number.)

CHANGING COINS
  "exchange {amount} {from} {to}" swaps coins at a banker. The coin types
  are copper, silver, gold and platinum (c, s, g and p also work).

    exchange 50 silver gold    turn 50 silver into 5 gold

  Rates are 10 copper = 1 silver, 10 silver = 1 gold, 10 gold = 1
  platinum. Your total wealth doesn't change; anything too small to fill
  a whole coin of the new type comes back to you as change.

ACCOUNT BANK AND CHEST
  Characters on the same website account can share money and items:
    account_balance                  the shared pool (abal)
    account_deposit {copper}         move copper from your character's bank
                                     balance into the shared pool
    account_withdraw {copper}        move it back
    chest                            list the shared item chest
    chest_deposit {item}             store an item (not soulbound or
                                     no-drop items)
    chest_withdraw {slot}            take an item back out

See also: SHOPS, MAIL.
