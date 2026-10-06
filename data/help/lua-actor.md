---
keywords: [lua-actor, actor, self, lua actor, actor api]
title: "Lua API: Actor (self, actor)"
category: building
min_level: 100
usage: "actor:method(args) / actor.field"
---
self and actor are Actor handles (players and mobs). Unknown fields read as nil
and fields are read-only. tostring(actor) gives "Actor(Name)"; use actor.name.
Methods (return type after ->; none means nothing useful):
  actor:say(msg)  actor:emote(msg)  actor:shout(msg)    room / world speech
  actor:send(msg)                                private line to this actor
  actor:whisper(target_name, msg)                whisper to someone in the room
  actor:command(line)              queue a command; runs after the script ends
  actor:move(direction)            walk through an exit (ignores door state)
  actor:teleport(room)             room is a Room handle
  actor:follow(leader)             leader is an Actor
  actor:damage(n)  actor:heal(n)   change HP (damage stops at 0, heal at max)
  actor:award_exp(n)  actor:save()                  players only
  actor:attack_all()               engage every player in the room
  actor:chant(name, target?, level?)   actor:perform(name, target?, level?)
  actor:breath_attack(element, target?)   cast breathe_<element>
  actor:set_flag(name, on)         mob behaviours: sentinel, stay_zone,
                                   scavenger, wimpy, helper, memory
  actor:has_skill(name) -> bool    actor:has_effect(name) -> bool
  actor:get_has_spell(name) -> bool    spell currently applied
  actor:has_item(zone, id) -> bool     carried or worn
  actor:has_equipped(zone, id) -> bool
  actor:get_worn(slot) -> Object|nil   slot e.g. "wield", "head", "body"
  actor:destroy_item(keyword)      "all.keyword" removes every match
  actor:spawn_object(zone, id) -> Object|nil   into the actor's inventory
  actor:room_name() -> string|nil
  actor:getvar(name) -> any|nil   actor:setvar(name, value)   actor:clearvar(name) -> bool
         persistent per-entity variables; MOBS AND ITEMS ONLY (silent no-op on
         players). Values: string, number, boolean, table; nil clears.
Quest variables (stored on the player):
  actor:get_quest_stage(q) -> int (0 = not started)   actor:start_quest(q)
  actor:advance_quest(q)   actor:complete_quest(q)   actor:fail_quest(q)
  actor:restart_quest(q)   actor:erase_quest(q)
  actor:get_has_completed(q) -> bool   actor:get_has_failed(q) -> bool
  actor:get_quest_var("q:var") -> string ("" when unset)
  actor:set_quest_var(q, var, value) or ("q:var", value)
  actor:active_quest(zone, id) -> Quest|nil, with :getvar(n) :setvar(n, v) :clearvar(n)
Fields: name, alias (first keyword), shortdesc, id, zone_id, level, class,
race, size, gender, title, exp, hp, max_hp (maxhit), alignment, position
(stance): standing/sitting/resting/sleeping/kneeling. Stats: armor, damroll
(attack_power), accuracy, evasion, real_str real_dex real_con real_int
real_wis real_cha. Booleans: is_player, is_mob (is_npc), is_fighting,
is_ghost, is_stunned, is_frozen, can_be_seen. hiddenness (0/1), flags (active
effect names, uppercase, space-separated), room (Room), group_size,
group_member[i] (1 = leader), pronouns possessive/hisher, subjective/heshe,
objective/himher.
