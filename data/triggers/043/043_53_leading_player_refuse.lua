-- Trigger: Leading Player refuse
-- Zone: 43, ID: 53
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #4353

-- Converted from DG Script #4353: Leading Player refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("bard_subclass") == 4 then
    _return_value = false
    actor:send(tostring(self.name) .. " says, 'This isn't the script I sent you for.'")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I sure hope you didn't memorize anything from that!'")
else
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Ummmmm, what exactly is this for?'")
end
return _return_value