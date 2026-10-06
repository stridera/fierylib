---
keywords: [triggers, scripts, scripting, trigger]
title: Triggers and Scripts
category: building
min_level: 100
usage: "triggers [here | <name> | <zone> <id> | full]"
---
A trigger is a Lua script plus a list of event flags. When something happens to
the entity the trigger is attached to (a mob is greeted, an item is picked up,
a player enters a room), the server runs the script body. Triggers are keyed by
(zone_id, id) like every other world entity.

Each trigger has:
  name        free text, shown in the Scripts list and in error reports
  attach type MOB, OBJECT or WORLD (WORLD triggers attach to rooms)
  flags       the events it fires on (see: help trigger-types)
  arguments   optional comma-separated list (stored, not interpreted by the server)
  body        the Lua source

Attaching: create and edit triggers in Muditor under Dashboard > Scripts (name,
attach type, flags, arguments, Lua editor with linter). A mob or object gets a
trigger through the attachTrigger mutation (MobTriggers / ObjectTriggers rows);
room attachments (RoomTriggers) are created by the fierylib import. A trigger
may be attached to many entities; it keeps one body.

Running and reloading: the server loads the whole trigger catalog from the
database at boot. After editing in Muditor, a Builder runs "treload" in game
(or POST /api/admin/triggers/reload). Body edits then apply to every existing
mob and item at once. Attachment changes apply to rooms immediately but only
reach mobs and objects on their NEXT spawn or respawn.

Each fire runs in its own sandbox: new globals you assign are private to that
fire, and a script is stopped after about 5 million Lua instructions.

Builder commands:
  triggers [here|<name>|<zone> <id>|full]  what is attached where
  tstat <zone> <id>                        flags, body and fire statistics
  trighistory [<target>] [<n>]             recent fires for an entity
  scripterrors [<n>]                       recent failures
  firetrig <zone> <id> [<actor>]           run a trigger by hand
  lua <code>                               run a snippet with actor = you

Related help: trigger-types, lua-actor, lua-room, lua-object, lua-world,
lua-examples, lua-pitfalls.
