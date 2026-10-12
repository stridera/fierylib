---
keywords: [sell]
title: Sell
category: command
min_level: 0
usage: "sell [#] <item> | sell <#>.<item> | sell all | sell all.<item>"
---
Usage: sell [#] <item>
       sell <#>.<item>

If you'd like to SELL an item to a shopkeeper, trying SELLING it to them.
Most shops specialize in what they will buy, so you may have to look
around to find a buyer for your items.

Examples:

  > sell sword       (sell the first sword in your inventory)
  > sell 3 sword     (sell three swords from your inventory, one after another)
  > sell 3.sword     (sell the third sword in your inventory)

  > sell all         (sell everything you carry that the shopkeeper wants)
  > sell all.sword   (sell every sword you carry)

With a number before the item name, SELL sells that many matching items.
With a number and a dot ("3.sword"), it sells only that one: the third
match. If the shopkeeper won't take an item, SELL skips it and says so.

A shopkeeper only buys the kinds of goods the shop deals in, and pays
less than the asking price. VALUE tells you what the shopkeeper would
pay before you sell.

See also: BUY, LIST, SHOPS, VALUE, INSPECT
