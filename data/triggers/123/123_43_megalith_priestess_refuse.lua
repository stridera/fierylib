-- Trigger: megalith_priestess_refuse
-- Zone: 123, ID: 43
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #12343

-- Converted from DG Script #12343: megalith_priestess_refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("megalith_quest")
local response  -- hoisted from converter's branch-scoped locals

if stage ~= 1 and stage ~= 3 then
    response = "I need your help with something else."
elseif stage == 1 then
    -- TODO(parity): legacy 5-digit object vnums; split to (zone, id) once
    -- the canonical mapping is settled.
    if (object.zone_id == 237 and object.id == 56) or (object.zone_id == 411 and object.id == 11) or (object.zone_id == 411 and object.id == 10) or (object.zone_id == 185 and object.id == 12) or (object.zone_id == 85 and object.id == 7) or (object.zone_id == 173 and object.id == 0) or (object.zone_id == 86 and object.id == 12) or (object.zone_id == 588 and object.id == 9) then
        return _return_value
    else
        response = "Unfortunately, that's not going to help empower the ritual."
    end
elseif stage == 3 then
    if (object.zone_id == 238 and object.id == 17) or (object.zone_id == 43 and object.id == 5) or (object.zone_id == 43 and object.id == 18) or (object.zone_id == 580 and object.id == 15) or (object.zone_id == 580 and object.id == 18) or (object.zone_id == 584 and object.id == 26) or (object.zone_id == 584 and object.id == 18) then
        return _return_value
    else
        response = "Unfortunately, that's not going to help empower the ritual."
    end
end
if response then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    self:say(tostring(response))
end
return _return_value
