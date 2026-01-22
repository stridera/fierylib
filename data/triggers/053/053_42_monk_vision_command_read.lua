-- Trigger: Monk Vision command read
-- Zone: 53, ID: 42
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 30 if statements
--
-- Original DG Script: #5342

-- Converted from DG Script #5342: Monk Vision command read
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: read
if not (cmd == "read") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "r" or cmd == "re" then
    _return_value = false
    return _return_value
end
local visionstage = actor:get_quest_stage("monk_vision")
-- switch on self.id
if self.id == 59006 then
    local place = 4328
    local stage = 1
    if actor:has_item("55582") then
        local hasgem = 1
    end
    if actor:has_equipped("390") then
        local hasvision = 1
    end
elseif self.id == 18505 then
    local place = 58707
    local stage = 2
    if actor:has_item("55591") then
        local hasgem = 1
    end
    if actor:has_equipped("391") then
        local hasvision = 1
    end
elseif self.id == 8501 then
    local place = 18597
    local stage = 3
    if actor:has_item("55623") then
        local hasgem = 1
    end
    if actor:has_equipped("392") then
        local hasvision = 1
    end
elseif self.id == 12532 then
    local place = 58102
    local stage = 4
    if actor:has_item("55655") then
        local hasgem = 1
    end
    if actor:has_equipped("393") then
        local hasvision = 1
    end
elseif self.id == 16209 then
    local place = 16057
    local stage = 5
    if actor:has_item("55665") then
        local hasgem = 1
    end
    if actor:has_equipped("394") then
        local hasvision = 1
    end
elseif self.id == 43013 then
    local place = 59054
    local stage = 6
    if actor:has_item("55678") then
        local hasgem = 1
    end
    if actor:has_equipped("395") then
        local hasvision = 1
    end
elseif self.id == 53009 then
    local place = 49079
    local stage = 7
    if actor:has_item("55710") then
        local hasgem = 1
    end
    if actor:has_equipped("396") then
        local hasvision = 1
    end
elseif self.id == 58415 then
    local place = 11820
    local stage = 8
    if actor:has_item("55722") then
        local hasgem = 1
    end
    if actor:has_equipped("397") then
        local hasvision = 1
    end
elseif self.id == 58412 then
    local place = 52075
    local stage = 9
    if actor:has_item("55741") then
        local hasgem = 1
    end
    if actor:has_equipped("398") then
        local hasvision = 1
    end
end
if place == actor.room and visionstage == "stage" and hasvision and hasgem then
    if actor:get_quest_var("monk_vision:visiontask4") then
        actor:send("<magenta>You have already expanded your mind to its current limits.</>")
        return _return_value
    else
        local continue = "yes"
    end
end
if continue == "yes" then
    if actor.is_fighting then
        actor:send("<magenta>You cannot properly focus while fighting!</>")
        return _return_value
    else
        actor:send("<magenta>You begin to read " .. tostring(self.shortdesc) .. "...</>")
        wait(4)
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        end
        if actor.room ~= "place" then
            actor:send("<magenta>You must be in the proper place to keep reading!</>")
            return _return_value
        end
        local i = 0
        while i < 3 do
            actor:send("<magenta>You continue to read...</>")
            wait(4)
            local i = i + 1
            if actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            end
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep reading!</>")
                return _return_value
            end
        end
        actor:send("<b:magenta>You feel your awareness broadening!</>")
        actor:set_quest_var("monk_vision", "visiontask4", 1)
    end
else
    _return_value = false
end
return _return_value