-- Trigger: mage_receive
-- Zone: 238, ID: 15
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #23815

-- Converted from DG Script #23815: mage_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Reset quest in tempest room
if world.count_mobiles("23803") > 0 then
    get_room(238, 90):at(function()
        run_room_trigger(23814)
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
globals.question = globals.question or true
-- switch on question
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