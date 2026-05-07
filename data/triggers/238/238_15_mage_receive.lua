-- Trigger: mage_receive
-- Zone: 238, ID: 15
-- Type: MOB, Flags: RECEIVE
--
-- The player hands over the blue flame after banishing the Tempest. The mage
-- consumes the flame, picks one of four random questions, stores it in a
-- global so mage_speak3 can score the answer, and recites it. Also resets the
-- Tempest room so a fresh quest can be started later (in case the player ever
-- comes back via the wrong-answer path).

-- If a Tempest is still in 238:90, reset its quest state.
if world.count_mobiles(238, 3) > 0 then
    get_room(238, 90):at(function()
        run_room_trigger(238, 14)
    end)
end
wait(1)
self:destroy_item("blue-flame")
wait(1)
self.room:send("The mage's face brightens.")
actor:send(tostring(self.name) .. " says, 'You have banished the Tempest!  Excellent!  I think I can use this to remove the ice...'")
self:emote("murmers some arcane phrases and the symbols on the wall begin to glow.")
wait(2)
actor:send(tostring(self.name) .. " says, 'It says...")
local question = random(1, 4)
globals.question = question
if question == 1 then
    actor:send("What is the race of the one from Ickle?'")
elseif question == 2 then
    actor:send("What is the race of the one who fought demons?'")
elseif question == 3 then
    actor:send("What is the class of the one who stood fourth in line from the right?'")
elseif question == 4 then
    actor:send("What is the favored enemy of the barbarian?'")
else
    actor:send(tostring(self.name) .. " says, 'Hrm... I can't seem to read it.'")
    wait(2)
    self:command("frown")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Something is terribly wrong.  I think you should notify a god immediately.'")
end
wait(2)
actor:send(tostring(self.name) .. " says, 'Do you have the answer?'")
