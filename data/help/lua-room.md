---
keywords: [lua-room, room, lua room, room api]
title: "Lua API: Room"
category: building
min_level: 100
usage: "get_room(zone, id) / actor.room / room:method(args)"
---
Get a Room handle from actor.room (the room an actor stands in), get_room(zone,
id), or self.room inside a WORLD (room) trigger. In a room trigger, self IS the
room, so self.room is the same room; self:send() would not reach players, use
self.room:send().

Methods (return type after ->; none means nothing useful):
  room:send(msg)                      to every player in the room
  room:send_except(actor, msg)        everyone but that actor
  room:send_to_adjacent(msg)          into every room an exit leads to
  room:find_actor(keyword) -> Actor|nil     this room only, substring match
  room:find_object(keyword) -> Object|nil   items on the floor only
  room:spawn_mobile(zone, id) -> Actor|nil  does not fire LOAD
  room:spawn_object(zone, id) -> Object|nil onto the floor
  room:purge()                        remove every mob here (not players/items)
  room:teleport_all(room)             move all actors here to another room
  room:exit(direction) -> Exit|nil    nil when there is no exit that way
  room:at(fn) -> whatever fn returns  just calls fn()
  room:weather() -> string            "clear" if the zone has none
  room:temp() -> string               "mild" if the zone has none
  room:sector() -> string             "FOREST", "CITY", "STRUCTURE", ...
  room:is_outdoor() -> bool
  room:getvar(name) -> any|nil   room:setvar(name, value)   room:clearvar(name) -> bool
          persistent variables; nil clears; value may be string, number,
          boolean or table.

Fields (read-only): room.id (also room.local_id), room.zone_id, room.name,
room.actors (also room.people: 1-based list of Actors, mobs and players),
room.actor_count.

Exit handles (from room:exit("north"); directions: north south east west up
down northeast northwest southeast southwest, short forms n s e w u d ne nw se
sw, plus in and out):
  exit:state() -> "open"|"closed"|"locked"|nil
  exit:hidden() -> bool
  exit:set_state{ open=bool, locked=bool, hidden=bool, description=string,
                  keywords={"gate","door"} }   any subset; locked=true wins
  exit:set_key(zone, id)               object that unlocks it; no args clears
  exit:set_destination(room)           re-target; nil clears

Changing an exit changes only this room's side. For a two-way door, also change
the exit from the room on the other side (get_room(zone, id):exit("south")).

Example:
  local gate = get_room(30, 12):exit("north")
  if gate and gate:state() == "locked" then
      gate:set_state{ locked = false, open = true }
  end
