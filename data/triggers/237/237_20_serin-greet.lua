-- Trigger: serin-greet
-- Zone: 237, ID: 20
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #23720

-- Converted from DG Script #23720: serin-greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- This is the beginning of the quest to rescue the elven prisoner.
if actor.id == -1 then
    if actor:get_quest_stage("sunfire_rescue") == 0 then
        actor.name:send("The prisoner looks up at " .. tostring(actor.name) .. " hopefully.")
        actor.name:send("The prisoner says, 'Can you help me?'")
    elseif actor:get_quest_stage("sunfire_rescue") == 1 then
        -- then if they have been sent on the quest already, they should have the boots
        -- or at least be reminded of it.
        actor.name:send("The prisoner says, 'Ah! Have you brought me the treasures from Templace?'")
        actor.name:send("'Please, give them to me! If you forgot what you need to do, you can ask me")
        actor.name:send("'for a <b:white>[progress]</> report.'")
    end
end