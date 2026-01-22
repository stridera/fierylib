-- Trigger: raph_get_mussel
-- Zone: 133, ID: 11
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #13311

-- Converted from DG Script #13311: raph_get_mussel
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor:get_quest_stage("get_raph_food") == 7 then
        if already_retrieved_mussel == 1 then
            self.room:send_except(actor, "The mussel slips from " .. tostring(actor.name) .. "'s fingers, splatting on the ground.")
            actor:send("The mussel slips from your hands, darn slimy things.")
            _return_value = false
        else
            actor.name:advance_quest("get_raph_food")
        end
    end
end
local already_retrieved_mussel = 1
globals.already_retrieved_mussel = globals.already_retrieved_mussel or true
return _return_value