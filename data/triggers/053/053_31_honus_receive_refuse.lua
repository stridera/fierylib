-- Trigger: Honus receive refuse
-- Zone: 53, ID: 31
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5331

-- Converted from DG Script #5331: Honus receive refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local treasurestage = actor:get_quest_stage("treasure_hunter")
local cloakstage = actor:get_quest_stage("rogue_cloak")
-- switch on object.id
if object.id == 380 or (object.zone_id == 588 and object.id == 1) or (object.zone_id == 555 and object.id == 85) or object.id == 381 or (object.zone_id == 173 and object.id == 7) or (object.zone_id == 555 and object.id == 93) or object.id == 382 or (object.zone_id == 103 and object.id == 8) or (object.zone_id == 556 and object.id == 19) or object.id == 383 or (object.zone_id == 123 and object.id == 25) or (object.zone_id == 556 and object.id == 59) or object.id == 384 or (object.zone_id == 430 and object.id == 22) or (object.zone_id == 556 and object.id == 63) or object.id == 385 or (object.zone_id == 238 and object.id == 10) or (object.zone_id == 556 and object.id == 74) or object.id == 386 or (object.zone_id == 510 and object.id == 13) or (object.zone_id == 557 and object.id == 14) or object.id == 387 or (object.zone_id == 584 and object.id == 10) or (object.zone_id == 557 and object.id == 40) or object.id == 388 or (object.zone_id == 520 and object.id == 9) or (object.zone_id == 557 and object.id == 41) or (object.zone_id == 615 and object.id == 14) or (object.zone_id == 53 and object.id == 10) or (object.zone_id == 43 and object.id == 19) or (object.zone_id == 53 and object.id == 11) or (object.zone_id == 161 and object.id == 3) or (object.zone_id == 53 and object.id == 12) or (object.zone_id == 502 and object.id == 15) or (object.zone_id == 53 and object.id == 13) or (object.zone_id == 481 and object.id == 1) or (object.zone_id == 53 and object.id == 14) or (object.zone_id == 160 and object.id == 9) or (object.zone_id == 53 and object.id == 15) or (object.zone_id == 550 and object.id == 8) or (object.zone_id == 53 and object.id == 16) or (object.zone_id == 490 and object.id == 41) or (object.zone_id == 53 and object.id == 17) or (object.zone_id == 584 and object.id == 1) or (object.zone_id == 53 and object.id == 18) or (object.zone_id == 534 and object.id == 100) or (object.zone_id == 534 and object.id == 101) or (object.zone_id == 534 and object.id == 105) or (object.zone_id == 534 and object.id == 106) or (object.zone_id == 53 and object.id == 19) then
    return _return_value
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'What is this for?'")
end
return _return_value