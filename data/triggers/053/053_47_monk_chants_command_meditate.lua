-- Trigger: Monk Chants command meditate
-- Zone: 53, ID: 47
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 17 if statements
--   Large script: 6338 chars
--
-- Original DG Script: #5347

-- Converted from DG Script #5347: Monk Chants command meditate
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
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = false
    return _return_value
end
-- switch on self.id
if self.id == 1807 then
    local visionstage = 3
    local chantstage = 1
    local level = 30
    local place = 3205
    if actor:has_equipped("393") or actor:has_equipped("394") or actor:has_equipped("395") or actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&3The power of the earth begins to flow through your fists!&0"
    local text2 = "&3You have learned Tremors of Saint Augustine.&0"
    local chant = "tremors of saint augustine"
elseif self.id == 12508 then
    local visionstage = 4
    local chantstage = 2
    local level = 40
    local place = 4752
    if actor:has_equipped("394") or actor:has_equipped("395") or actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&4&bThe power of the storm begins to flow through your fists!&0"
    local text2 = "&4&bYou have learned Tempest of Saint Augustine.&0"
    local chant = "tempest of saint augustine"
elseif self.id == 55003 then
    local visionstage = 5
    local chantstage = 3
    local level = 50
    local place = 11837
    if actor:has_equipped("395") or actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&6&bThe power of ice begins to flow through your fists!&0"
    local text2 = "&6&bYou have learned Blizzards of Saint Augustine.&0"
    local chant = "blizzards of saint augustine"
elseif self.id == 55004 then
    local visionstage = 6
    local chantstage = 4
    local level = 60
    local place = 2786
    if actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&bReverberating from the walls are the discordant words of power!&0"
    local text2 = "&bYou have learned Aria of Dissonance.&0"
    local chant = "aria of dissonance"
elseif self.id == 49066 then
    local visionstage = 7
    local chantstage = 5
    local level = 75
    local place = 16057
    if actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&5The roaring of the dead forms into a chant!&0"
    local text2 = "&5You have learned Apocalyptic Anthem.&0"
    local chant = "apocalyptic anthem"
elseif self.id == 23826 then
    local visionstage = 8
    local chantstage = 6
    local level = 80
    local place = 5272
    if actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&1&bThe power of fire begins to flow through your fists!&0"
    local text2 = "&1&bYou have learned Fires of Saint Augustine.&0"
    local chant = "fires of saint augustine"
elseif self.id == 48037 then
    local visionstage = 9
    local chantstage = 7
    local level = 99
    local place = 48913
    if actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&9&bThe chant to engender catastrophe echoes from the altar!&0"
    local text2 = "&9&bYou have learned Seed of Destruction.&0"
    local chant = "seed of destruction"
end
if actor:get_quest_stage("monk_vision") > visionstage and actor:get_quest_stage("monk_chants") == "chantstage" and actor.level >= level and actor.room == "place" then
    if mark then
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
            actor:send(tostring(text1))
            actor:send(tostring(text2))
            skills.set_level(actor, "%chant%", 100)
            if actor:get_quest_stage("monk_chants") < 7 then
                actor:advance_quest("monk_chants")
            else
                actor:complete_quest("monk_chants")
            end
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