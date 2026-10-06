---
keywords: [lua-object, object, item, lua object, object api]
title: "Lua API: Object"
category: building
min_level: 100
usage: "object.field / obj:getvar(name)"
---
Items are the same kind of handle as actors, so everything on "help lua-actor"
exists on them, but only the item-related parts are meaningful. Item handles
come from: self in OBJECT triggers, the object global (RECEIVE only),
actor:get_worn(slot), actor:spawn_object, room:find_object, room:spawn_object.

Fields (read-only; unknown names read as nil):
  object.id, object.zone_id    -> int     prototype id (zone_id, id)
  object.name                  -> string
  object.alias                 -> string  first keyword
  object.shortdesc             -> string  examine text, else the name
  object.level                 -> int
  object.cost                  -> int     base value, copper
  object.type                  -> string  "WEAPON", "ARMOR", ... uppercase
  object.weight                -> number
  object.worn_by               -> Actor|nil   who has it equipped; nil when it is
                                  in a container, on the floor or merely carried
Variables (persistent, saved to the database):
  object:getvar(name) -> any|nil
  object:setvar(name, value)           nil clears
  object:clearvar(name) -> bool

Things you do TO items, from the other handles:
  actor:has_item(zone, id) -> bool         carried or worn
  actor:has_equipped(zone, id) -> bool     worn only
  actor:get_worn(slot) -> Object|nil
  actor:destroy_item(keyword)              "all.keyword" removes every match
  actor:spawn_object(zone, id) -> Object|nil   into inventory
  room:spawn_object(zone, id) -> Object|nil    onto the floor
  room:find_object(keyword) -> Object|nil
  world.destroy(handle)                    delete any item or mob
  world.count_objects(zone, id) -> int     live copies in the world
  objects.template(zone, id) -> Proto      read-only: .id .zone_id .name .shortdesc,
                                           works without spawning

Item events (GET DROP WEAR REMOVE USE CONSUME): self = the item, actor = the
player, object is nil. Use self.id / self.zone_id to identify the item.
RECEIVE on a mob: object = the item handed over.

Example, a cursed ring that drains whoever wears it (OBJECT trigger, flag WEAR):
  local wearer = actor
  wearer:send("The ring tightens painfully around your finger.")
  wearer:damage(5)
  self:setvar("worn_count", (self:getvar("worn_count") or 0) + 1)
