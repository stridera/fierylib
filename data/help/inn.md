---
keywords: [inn, inns, housing, house, houses, reception]
title: Inns, Rent and Houses
category: guide
min_level: 0
usage: "rent [{room}] | house [info|enter|rooms|guests|expand] | visit {player}"
---
INNS
  Inns are rooms flagged by the builders. Inside one, "rent" lists the
  rooms on offer and their prices in gold:

    rent               list the rooms and fees
    rent suite         book the room called suite (abbreviations work)

  The fee is flat for each room tier, not per night. The cheapest tier
  books immediately; tiers 2 and 3 ask you to confirm with y or n. Booking
  sets your rest source to the inn: on your next experience gain you get
  the Refreshed regeneration bonus (plus any extras the room carries) and
  the booking is used up. Booking a lower tier after a higher one replaces
  it with no refund. Outside an inn, rent tells you there is nothing to
  rent.

PLAYER HOUSES
  Houses are granted by the builders; if you have none, "house" says so.
  Once you own one:

    house               summary (same as house info)
    house enter         go to your house
    house rooms         list rooms, their contents and capacity
    house guests        list who may visit
    house place {item}  put an item from your inventory in the room
    house take {item}   pick it up again
    house rename 1 Library       rename room 1
    house describe 1 {text}      set room 1's description
    house guest add {name} [place]   allow a visitor ("place" also lets
                                     them put items down)
    house guest remove {name}
    house expand        add a room off the foyer's north exit. It costs
                        copper, more for each room you already have; the
                        game states the price and you need the coin on hand.

  Others enter with "visit {player}", which only works if the owner has
  added them as a guest.

See also: BANK, SHOPS, GETTING-STARTED.
