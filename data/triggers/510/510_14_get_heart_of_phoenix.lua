-- Trigger: get_heart_of_phoenix
-- Zone: 510, ID: 14
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #51014

-- Converted from DG Script #51014: get_heart_of_phoenix
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
-- this is only an issue if the heart has not already been got...
if already_got ~= 1 then
    -- need to be wearing (on hands) object 51026 to get heart
    if actor:has_equipped("51026") then
        actor:send("The corpse is extremely hot and may combust soon!")
        actor:award_exp(30000)
        _return_value = true
        local already_got = 1
        globals.already_got = globals.already_got or true
    else
        actor:send("The corpse is too hot to touch without special protection!")
        _return_value = false
    end
    wait(2)
    self.room:send("The corpse suddenly crumbles to ash.")
end
return _return_value