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
if object.id == 380 or object.id == 58801 or object.id == 55585 or object.id == 381 or object.id == 17307 or object.id == 55593 or object.id == 382 or object.id == 10308 or object.id == 55619 or object.id == 383 or object.id == 12325 or object.id == 55659 or object.id == 384 or object.id == 43022 or object.id == 55663 or object.id == 385 or object.id == 23810 or object.id == 55674 or object.id == 386 or object.id == 51013 or object.id == 55714 or object.id == 387 or object.id == 58410 or object.id == 55740 or object.id == 388 or object.id == 52009 or object.id == 55741 or object.id == 61514 or object.id == 5310 or object.id == 4319 or object.id == 5311 or object.id == 16103 or object.id == 5312 or object.id == 50215 or object.id == 5313 or object.id == 48101 or object.id == 5314 or object.id == 16009 or object.id == 5315 or object.id == 55008 or object.id == 5316 or object.id == 49041 or object.id == 5317 or object.id == 58401 or object.id == 5318 or object.id == 53500 or object.id == 53501 or object.id == 53505 or object.id == 53506 or object.id == 5319 then
    return _return_value
else
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'What is this for?'")
end
return _return_value