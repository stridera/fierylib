-- Trigger: LP_receive
-- Zone: 43, ID: 64
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #4364

-- Converted from DG Script #4364: LP_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local response
-- switch on object.id
do
    if actor:get_quest_stage("bard_subclass") > 0 then
        response = "Nah nah nah.  We need to go down to the studio before you do anything else.  You ready to keep going?"
    else
        response = "Ummmmm, what exactly is this for?"
    end
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value