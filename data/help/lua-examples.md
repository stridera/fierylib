---
keywords: [lua-examples, lua examples, script examples, trigger examples]
title: "Lua Script Examples"
category: building
min_level: 100
usage: "attach with Muditor Dashboard > Scripts, then treload"
---
1. Greeting mob (MOB trigger, flag GREET). Greets players only, remembers who
it already welcomed, and throttles with the clock. Ids below are examples.

  if not actor.is_player then return end
  wait(1)
  local last = self:getvar("greeted_" .. actor.name) or 0
  if time.stamp - last < 600 then return end
  self:setvar("greeted_" .. actor.name, time.stamp)
  self:say("Welcome, " .. actor.name .. "!")
  self:command("bow " .. actor.name)

2. Locked-door puzzle (MOB trigger on a gatekeeper, flag RECEIVE). Handing the
guard item (zone 30, id 12) opens the north gate for a while, then it relocks.

  if not (object and object.zone_id == 30 and object.id == 12) then
      self:say("I have no use for that.")
      return
  end
  self:destroy_item("pass")
  local gate = self.room:exit("north")
  if not gate then return end
  gate:set_state{ locked = false, open = true }
  self.room:send(self.name .. " swings the gate open.")
  wait(60)
  gate:set_state{ open = false, locked = true }
  self.room:send("The gate clanks shut and locks.")

3. Timed event (WORLD trigger on a room, flag POSTENTRY). Entering starts a
cave-in after a delay, at most once every two minutes. The timestamp lives in
a room variable, so a restart mid-wait cannot leave the room stuck "armed".

  local room = self.room
  if time.stamp - (room:getvar("last_collapse") or 0) < 120 then return end
  room:setvar("last_collapse", time.stamp)
  room:send("Dust sifts from the ceiling. The walls groan.")
  wait(10)
  room:send("The ceiling collapses!")
  for _, who in ipairs(room.actors) do
      if who.is_player then
          who:damage(20)
          who:send("Falling rock batters you.")
      end
  end

Real scripts to read: fierylib/data/triggers/030/ (e.g. 030_167_calken_greet,
030_33_magistrate_speech_wug). Test with "firetrig <zone> <id>" or the lua
command, and check "scripterrors" afterwards.
