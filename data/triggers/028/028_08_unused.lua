-- Trigger: **UNUSED**
-- Zone: 28, ID: 8
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <**UNUSED**>:24: function arguments expected near ']'
--   Complex nesting: 15 if statements
--   Large script: 7018 chars
--
-- Original DG Script: #2808

-- Converted from DG Script #2808: **UNUSED**
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
local i = actor.group_size
if i then
    while i > 0 do
        local person = actor.group_member[i]
        if person.room == self.room then
            if person:get_quest_stage("waterform") == 4 and (person:has_item("2808") or person:has_equipped("2808")) then
                -- switch on self.id
                if self.id == 2805 or self.id == 2808 or self.id == 2809 or self.id == 11805 then
                    local number = 1
                elseif self.id == 51001 or self.id == 51019 or self.id == 51021 then
                    local number = 2
                elseif self.id == 4002 then
                    local number = 3
                elseif self.id == 48631 then
                    local number = 4
                elseif self.id == 53004 then
                    local number = 5
                else
                    _return_value = true
                end
                if person.quest_variable[waterform:regionnumber] == 0 then
                    person.name:set_quest_var("waterform", "region%number%", 1)
                    person:send("<b:blue>You gather part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
                    self.room:send_except(person, "<b:blue>" .. tostring(person.name) .. " gathers part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
                end
                local region1 = person:get_quest_var("waterform:region1")
                local region2 = person:get_quest_var("waterform:region2")
                local region3 = person:get_quest_var("waterform:region3")
                local region4 = person:get_quest_var("waterform:region4")
                local region5 = person:get_quest_var("waterform:region5")
                if region1 + region2 + region3 + region4 + region5 > 3 then
                    person:send("<b:blue>You have gathered all the samples of living water you need!</>")
                    person.name:advance_quest("waterform")
                end
            end
        end
        i = i - 1
    end
elseif actor:get_quest_stage("waterform") == 4 and (actor:has_item("2808") or actor:has_equipped("2808")) then
    -- switch on self.id
    if self.id == 2805 or self.id == 2808 or self.id == 2809 or self.id == 11805 then
        local number = 1
    elseif self.id == 51001 or self.id == 51019 or self.id == 51021 then
        local number = 2
    elseif self.id == 4002 then
        local number = 3
    elseif self.id == 48631 then
        local number = 4
    elseif self.id == 53004 then
        local number = 5
    else
        _return_value = true
    end
    if actor.quest_variable[waterform:regionnumber] == 0 then
        actor.name:set_quest_var("waterform", "region%number%", 1)
        actor:send("<b:blue>You gather part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
        self.room:send_except(actor, "<b:blue>" .. tostring(actor.name) .. " gathers part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
    end
    local region1 = actor:get_quest_var("waterform:region1")
    local region2 = actor:get_quest_var("waterform:region2")
    local region3 = actor:get_quest_var("waterform:region3")
    local region4 = actor:get_quest_var("waterform:region4")
    local region5 = actor:get_quest_var("waterform:region5")
    if region1 + region2 + region3 + region4 + region5 > 3 then
        actor:send("<b:blue>You have gathered all the samples of living water you need!</>")
        actor.name:advance_quest("waterform")
    end
end
-- 
-- p3 mini boss death trigger 55599
-- 
-- Death trigger for random gem and armor drops
-- 
-- set a random number to determine if a drop will
-- happen.
-- 
-- Miniboss setup
-- 
local bonus = random(1, 100)
local will_drop = random(1, 100)
-- 4 pieces of armor per sub_phase in phase_3
local what_armor_drop = random(1, 4)
-- 11 classes questing in phase_3
local what_gem_drop = random(1, 11)
-- 
if will_drop <= 30 then
    -- drop nothing and bail
    return _return_value
end
if will_drop <= 70 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        self.room:spawn_object(557, 14 + what_gem_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(557, 25 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(557, 36 + what_gem_drop)
    end
elseif will_drop >= 71 &will_drop <= 90 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- 
        self.room:spawn_object(553, 71 + what_armor_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, 75 + what_armor_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, 79 + what_armor_drop)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(557, 14 + what_gem_drop)
        self.room:spawn_object(553, 71 + what_armor_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, 75 + what_armor_drop)
        self.room:spawn_object(557, 25 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(557, 36 + what_gem_drop)
        self.room:spawn_object(553, 79 + what_armor_drop)
    end
end
return _return_value