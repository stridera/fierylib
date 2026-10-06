---
keywords: [lua-pitfalls, pitfalls, lua errors, script errors, scripterrors, debugging]
title: "Lua Pitfalls and Debugging"
category: building
min_level: 100
usage: "scripterrors [<n>]"
---
Common mistakes:
  1. Locals in branches. "local x" inside if/elseif is scoped to that branch;
     declare it before the if. Converted DG scripts often get this wrong.
  2. No get.* global. DG "%get.obj_shortdesc[...]%" has no equivalent name; use
     objects.template(zone, id).name or the actor:get_* methods.
  3. No vnum. self.vnum / actor.vnum read as nil without any error. Use
     (zone_id, id): self.zone_id and self.id; objects.template(zone, id).
     Legacy id 3045 is zone 30, id 45.
  4. time.stamp exists here (Unix seconds) and so do hour, minute, day, month,
     year, month_name, season, is_night, is_day. After a wait() the table
     only has stamp, hour, day, month, year. The DG "%time.stamp%" text does
     not work in Lua; write time.stamp.
  5. Unknown fields are nil and fields are read-only: a typo (actor.levl) is
     silent, and "self.hp = 5" raises an error. Use damage() / heal().
  6. get_quest_var returns a string, "" when unset (which is truthy). Compare
     with tonumber(...) or == "".
  7. tostring(actor) is "Actor(Name)". Build commands with actor.name.
  8. In SPEECH fired by "say", actor equals self (the listener); only "ask"
     gives the speaker. Match keywords against the speech global (lowercase).
  9. object is nil except in RECEIVE. In item events self is the item.
 10. setvar / getvar do nothing on players; use quest variables.
 11. In room triggers self is the room: use self.room:send(...).
 12. actor:command runs after the script finishes, not at that line.
 13. Flags with no dispatcher (RANDOM, TIME, ...) never fire. See trigger-types.
 14. wait() scripts die on restart; errors after a wait are not logged.
 15. Output: print() is not shown to players. Do not add \r\n.
 16. Endless loops stop at about 5 million instructions with an "instruction
     budget" error. Always wait() inside loops that poll.

Finding errors:
  scripterrors [<n>]                   newest first, default 20
  GET /api/admin/triggers/errors?limit=N   (admin HTTP, 127.0.0.1:8080)
      -> { total, errors: [ { secs_ago, trigger_zone, trigger_id,
           trigger_name, event, message } ] }, newest first, default 50. The
      log is in memory and also written to the script_error_log table.
      message starts "lua error:" and names the line, for example
      "attempt to index a nil value (field 'x')".
  GET /api/admin/triggers/validate[?zone=N]   compile-checks bodies
  GET /api/admin/triggers/stats               fire counts per event
  tstat <zone> <id>, trighistory <target>     per-trigger / per-entity history
Muditor shows a syntax error and lint warnings in the Scripts editor; fix those
first. Remember "treload" after saving.
