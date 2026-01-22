-- Trigger: **UNUSED**
-- Zone: 53, ID: 53
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #5353

-- Converted from DG Script #5353: **UNUSED**
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
-- For Seed of Destruction on item 48037
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("monk_vision") >= 9 and actor:get_quest_stage("monk_chants") == 7 and actor.level == 99 and actor.room == 48913 then
    if actor:has_equipped("399") then
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
            actor:send("&9<blue>The chant to engender catastrophe echoes from the altar!</>")
            actor:send("&9<blue>You have learned Seed of Destruction.</>")  -- typo: sent
            skills.set_level(actor, "seed of destruction", 100)
            actor:complete_quest("monk_chants")
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