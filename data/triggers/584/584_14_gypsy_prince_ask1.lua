-- Trigger: Gypsy_Prince_ask1
-- Zone: 584, ID: 14
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #58414

-- Converted from DG Script #58414: Gypsy_Prince_ask1
-- Original: MOB trigger, flags: SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
if actor:get_quest_stage("major_spell_quest") == 2 then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says to you, 'Greetings, traveler what brings you to my camp?'")
    self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
else
end