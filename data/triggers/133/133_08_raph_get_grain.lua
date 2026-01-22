-- Trigger: raph_get_grain
-- Zone: 133, ID: 8
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #13308

-- Converted from DG Script #13308: raph_get_grain
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor:get_quest_stage("get_raph_food") == 1 then
        if already_retrieved_grain == 1 then
            self.room:send_except(actor, "The grain flows through " .. tostring(actor.name) .. "'s hand, making a")
            -- Fragment (possible truncation): pile appear on the floor
            actor:send("The grain pass between your fingers, scratching you on the way.")
            actor:damage(53)  -- type: physical
            _return_value = false
        else
            actor.name:advance_quest("get_raph_food")
        end
    end
end
local already_retrieved_grain = 1
globals.already_retrieved_grain = globals.already_retrieved_grain or true
return _return_value