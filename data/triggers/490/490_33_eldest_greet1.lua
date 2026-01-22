-- Trigger: eldest_greet1
-- Zone: 490, ID: 33
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #49033

-- Converted from DG Script #49033: eldest_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 and actor.level < 100 then
    wait(1)
    -- switch on actor:get_quest_stage("major_globe_spell")
    if actor:get_quest_stage("major_globe_spell") == 2 then
        self:say("Have you brought shale from the nearby island, " .. tostring(actor.name) .. "?")
    elseif actor:get_quest_stage("major_globe_spell") == 3 then
        self:say("Do you have the sake, " .. tostring(actor.name) .. "?")
    elseif actor:get_quest_stage("major_globe_spell") == 4 then
        self:say("Did you find the healer's poultice, " .. tostring(actor.name) .. "?")
    else
        self:say("Looks like another bad year for mistletoe.  If only we could get rid of those griffins, we might have a chance.")
    end
end