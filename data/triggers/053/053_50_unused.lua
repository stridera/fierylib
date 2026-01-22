-- Trigger: **UNUSED**
-- Zone: 53, ID: 50
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #5350

-- Converted from DG Script #5350: **UNUSED**
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
-- For Aria of Dissonance on item 55004
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("monk_vision") > 6 and actor:get_quest_stage("monk_chants") == 4 and actor.level >= 60 and actor.room == 2786 then
    if actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
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
            actor:send("<blue>Reverberating from the walls are the discordant words of power!</>")
            actor:send("<blue>You have learned Aria of Dissonance.</>")
            skills.set_level(actor, "aria of dissonance", 100)
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