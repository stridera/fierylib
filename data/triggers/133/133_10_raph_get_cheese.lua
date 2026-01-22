-- Trigger: raph_get_cheese
-- Zone: 133, ID: 10
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #13310

-- Converted from DG Script #13310: raph_get_cheese
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor:get_quest_stage("get_raph_food") == 5 then
        if already_retrieved_cheese == 1 then
            self.room:send_except(actor, "The cheese turns to a mushy goo in " .. tostring(actor.name) .. "'s hands.")
            actor:send("You squished the cheese into goo!")
            _return_value = false
        else
            actor.name:advance_quest("get_raph_food")
        end
    end
end
local already_retrieved_cheese = 1
globals.already_retrieved_cheese = globals.already_retrieved_cheese or true
return _return_value