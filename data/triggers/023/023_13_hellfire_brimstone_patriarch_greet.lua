-- Trigger: hellfire_brimstone_patriarch_greet
-- Zone: 23, ID: 13
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #2313

-- Converted from DG Script #2313: hellfire_brimstone_patriarch_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(0.2)
local stage = actor:get_quest_stage("hellfire_brimstone")
-- switch on stage
do
    local _sw1 = string.lower(tostring(stage or ""))
    if tonumber(_sw1) == 1 then
        self.room:send(tostring(self.name) .. " says, 'Have you brought me more meat?  <b:cyan>[Drop]</> it here if you have.'")
    elseif tonumber(_sw1) == 2 then
        self.room:send(tostring(self.name) .. " says, 'Have you found brimstone?  <b:cyan>[Drop]</> it here if you have.'")
    elseif tonumber(_sw1) == 3 then
        self:say("Give me any appropriate tributes you have found.")
    else
        if actor.level > 57 and string.find(actor.class, "diabolist") then
            self:say("You seem to be quite powerful...  Powerful enough in fact to handle the Fire of the Dark One.")
            wait(2)
            self:say("Would you like to learn to rain fire and brimstone down on your enemies?")
        end
    end
end