-- Trigger: Rhell merchant refuse
-- Zone: 625, ID: 19
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62519

-- Converted from DG Script #62519: Rhell merchant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local response
if actor:get_has_completed("ursa_quest") then
    response = "I don't really need this."
elseif not actor:get_quest_stage("ursa_quest") or actor:get_quest_stage("ursa_quest") == 0 then
    response = "I don't think this will help me."
elseif actor:get_quest_stage("ursa_quest") == 1 then
    -- Three letter-objects (625, 10/11/12) advance the quest; pass them through.
    if object.zone_id == 625 and (object.local_id == 10 or object.local_id == 11 or object.local_id == 12) then
        return true
    else
        response = "This isn't helpful."
    end
end
if not response then
    return true
end
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(1)
self:say(tostring(response))
if actor:get_quest_stage("ursa_quest") == 1 then
    wait(2)
    self:say("Maybe you could ask someone who might know.")
end
return true
