---
keywords: [trigger-types, trigger types, trigger flags, flags]
title: Trigger Types and Variables
category: building
min_level: 100
usage: "see also: tstat <zone> <id>"
---
Flags a trigger can carry, when the server fires them, and what self / actor /
object are. self is always the entity the trigger is attached to.

Fired by the server today:
  LOAD       mob   Mob spawns (boot and respawn). self = actor = the mob.
                   Not fired for mobs made by room:spawn_mobile.
  GREET      mob   A player or mob arrives in the room. self = listener,
  GREET_ALL        actor = arriver. Both flags behave identically.
  SPEECH     mob   Someone uses "say" in the room, or "ask <mob> <topic>".
                   Global speech = the text, lowercased.
                   Via say, actor is the same entity as self (the speaker is
                   not available). Via ask, actor = the asker.
  RECEIVE    mob   A player gives the mob an item. self = mob, actor = giver,
                   object = the item (the only event that sets object).
  COMMAND    mob   A player types any command while in the same room (mob or
                   item triggers; room triggers are not asked). Globals cmd
                   (command word) and args (rest of line). actor = typist.
                   "return false" consumes the command.
  FIGHT      mob   After each combat round while it is a target. self = target,
                   actor = attacker. Throttle with time.stamp.
  ATTACK     mob   A player starts an attack on it. self = target, actor = attacker.
  DEATH      mob   Just before the mob dies. self = actor = the mob.
  GET, DROP, WEAR, REMOVE, USE, CONSUME   object
                   self = the item, actor = the player. object is nil.
  PREENTRY   room  Before movers enter. self = the room, actor = mover.
  POSTENTRY  room  After the mover arrives and GREET ran. Same bindings.

Flag-less: run_room_trigger(zone, id) runs ALL triggers on that room whatever
their flags (self = room). The firetrig command and /api/admin/triggers/fire
also run a body directly.

Defined in the schema but NOT fired by the Rust server (no dispatcher yet):
GLOBAL RANDOM CAST LEAVE TIME ACT ENTRY HIT_PERCENT BRIBE MEMORY DOOR SPEECH_TO
LOOK AUTO DEFEND TIMER GIVE RESET. A trigger carrying only these never runs by
itself; for periodic behaviour use wait() loops started from LOAD, or
run_room_trigger.

Listeners for GREET, SPEECH, COMMAND are things located in the same room that
have triggers (mobs, and items lying on the floor).

Return value: only COMMAND looks at it. "return false" stops the typed
command; anything else lets it continue.
