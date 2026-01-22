-- Trigger: chalice_retrieval
-- Zone: 185, ID: 13
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #18513

-- Converted from DG Script #18513: chalice_retrieval
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if self.room == 8591 then
    -- we are in chalice room so set the quest bit
    if actor:get_quest_stage("pri_pal_subclass") == 2 then
        if already_got == 1 then
            self.room:send_except(actor, "The chalice slips from " .. tostring(actor.possessive) .. " fingers!")
            actor:send("The chalice slips from your fingers!")
            _return_value = false
        else
            actor.name:advance_quest("pri_pal_subclass")
        end
    end
    local already_got = 1
    globals.already_got = globals.already_got or true
end
return _return_value