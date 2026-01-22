-- Trigger: raph_get_donuts
-- Zone: 133, ID: 9
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #13309

-- Converted from DG Script #13309: raph_get_donuts
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor:get_quest_stage("get_raph_food") == 3 then
        if already_retrieved_donuts == 1 then
            self.room:send_except(actor, "The donuts crumble in " .. tostring(actor.name) .. "'s hands, turning to dust.")
            actor:send("The donuts crumble to dust in your hands, turning to dust.")
            _return_value = false
        else
            actor.name:advance_quest("get_raph_food")
        end
    end
end
local already_retrieved_donuts = 1
globals.already_retrieved_donuts = globals.already_retrieved_donuts or true
return _return_value