-- Trigger: Ill-subclass: Grand Master restarts
-- Zone: 172, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player says 'restart'. The Grand Master refreshes the Cestia disguise
-- and hands them a fresh vial of disturbance so they can try the heist
-- again.
--
-- Original DG Script: #17204

local speech_lower = string.lower(speech)
if not string.find(speech_lower, "restart") then
    return true  -- keyword not heard
end

if string.find(actor.class, "Sorcerer")
    and actor.level > 9 and actor.level < 46
    and actor:get_quest_stage("illusionist_subclass") > 0 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Very well, if you insist.'")
    actor:restart_quest("illusionist_subclass")
    wait(1)
    self:emote("rummages about in his things.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Here is another vial.'")
    wait(1)
    self.room:spawn_object(172, 15)
    self:command("give vial " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'And don't muck it up this time!'")
end