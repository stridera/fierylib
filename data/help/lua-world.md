---
keywords: [lua-world, world, lua globals, globals, lua functions]
title: "Lua API: World and Global Functions"
category: building
min_level: 100
usage: "get_room(zone, id) / find_actor(keyword) / wait(seconds)"
---
Globals every trigger can use (return type after ->):
  get_room(zone, id) -> Room|nil
  find_actor(keyword) -> Actor|nil      whole world, first match; keyword is a
                                        case-insensitive substring of name/keywords
  random(low, high) -> int              inclusive; use this, not math.random
  percent_chance(n) -> bool             true n percent of the time
  wait(seconds)                         pause the script, then continue (>= 1)
  wait_until(hour, minute)              pause until that game time (minute optional)
  run_room_trigger(zone, id)            run every trigger on that room; deferred
                                        to after the current script finishes
  print(...)                            captured, NOT shown to players here;
                                        use actor:send / room:send instead
  globals                               scratch table, empty on every fire
World queries (namespace "world"):
  world.count_mobiles(zone, id) -> int  world.count_objects(zone, id) -> int
  world.find_mobile(zone, id) -> Actor|nil
  world.destroy(handle)                 despawn a mob or item
Prototypes (no spawn): mobiles.template(zone, id), objects.template(zone, id)
  -> read-only Proto with .id .zone_id .name .shortdesc
Combat (self is the fighter): combat.engage(target)   combat.rescue(victim)
Abilities:
  skills.set_level(actor, name, level)    grant or set a skill
  skills.execute(caster, name, target?)   target is an Actor or a name string
  spells.cast(caster, name, target?, level?)
  Effect.Name                             constant for has_effect, e.g.
                                          actor:has_effect(Effect.Sanctuary)
Clock (namespace "time", read-only snapshot taken when the script starts):
  time.stamp          Unix seconds (use for throttling: now - last > 5)
  time.hour 0-23, time.minute, time.day, time.month, time.year
  time.month_name, time.season, time.is_night, time.is_day
  One game hour is about 75 real seconds.
Event globals (strings): speech (SPEECH, lowercased), cmd and args (COMMAND).
Lua standard libraries: string, table, math, utf8, coroutine (read-only copies),
plus pairs, ipairs, tostring, tonumber, type, select, pcall, error, assert.
Removed: os, io, debug, package, require, load, loadstring, loadfile, dofile.
Limits: about 5 million instructions per run, 64 MB memory.
Persistent variables: obj:setvar / getvar / clearvar on mobs, items and rooms;
quest variables on players (see help lua-actor). Mob and item variables are
saved to the database about every 10 seconds.
Timing: wait(n) is real seconds. A script parked in wait() is lost on server
restart, and errors raised after a wait are not reported in the error log.
Messages sent from Lua already end with a newline; do not add \r\n.
