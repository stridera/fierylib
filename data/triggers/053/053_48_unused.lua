-- Trigger: **UNUSED**
-- Zone: 53, ID: 48
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #5348

-- Converted from DG Script #5348: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- For Tempest of Saint Augustine on item 12508
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("monk_vision") > 4 and actor:get_quest_stage("monk_chants") == 2 and actor.level >= 40 and actor.room == 58186 then
    if actor:has_equipped("394") or actor:has_equipped("395") or actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                local i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send("<b:yellow>The power of the storm begins to flow through your fists!</>")
            actor:send("<b:yellow>You have learned Tempest of Saint Augustine.</>")
            skills.set_level(actor, "tempest of saint augustine", 100)
            actor:advance_quest("monk_chants")
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value