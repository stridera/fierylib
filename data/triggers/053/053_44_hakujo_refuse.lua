-- Trigger: Hakujo refuse
-- Zone: 53, ID: 44
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5344

-- Converted from DG Script #5344: Hakujo refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local treasurestage = actor:get_quest_stage("elemental_chaos")
local visionstage = actor:get_quest_stage("monk_vision")
-- switch on object.id
if object.id == 390 or (object.zone_id == 590 and object.id == 6) or (object.zone_id == 555 and object.id == 82) or object.id == 391 or (object.zone_id == 185 and object.id == 5) or (object.zone_id == 555 and object.id == 91) or object.id == 392 or (object.zone_id == 85 and object.id == 1) or (object.zone_id == 556 and object.id == 23) or object.id == 393 or (object.zone_id == 125 and object.id == 32) or (object.zone_id == 556 and object.id == 55) or object.id == 394 or (object.zone_id == 162 and object.id == 9) or (object.zone_id == 556 and object.id == 65) or object.id == 395 or (object.zone_id == 430 and object.id == 13) or (object.zone_id == 556 and object.id == 78) or object.id == 396 or (object.zone_id == 530 and object.id == 9) or (object.zone_id == 557 and object.id == 10) or object.id == 397 or (object.zone_id == 584 and object.id == 15) or (object.zone_id == 557 and object.id == 22) or object.id == 398 or (object.zone_id == 584 and object.id == 12) or (object.zone_id == 557 and object.id == 41) or (object.zone_id == 53 and object.id == 20) or (object.zone_id == 53 and object.id == 21) or (object.zone_id == 53 and object.id == 22) or (object.zone_id == 53 and object.id == 23) or (object.zone_id == 53 and object.id == 24) or (object.zone_id == 53 and object.id == 25) or (object.zone_id == 53 and object.id == 26) or (object.zone_id == 53 and object.id == 27) or (object.zone_id == 53 and object.id == 28) or (object.zone_id == 53 and object.id == 29) then
    return _return_value
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'What is this for?'")
end
return _return_value