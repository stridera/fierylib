-- Trigger: waterform_water_death
-- Zone: 28, ID: 5
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2805

-- Converted from DG Script #2805: waterform_water_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("waterform") == 4 and (person:has_item("2808") or person:has_equipped("2808")) then
                -- switch on self.id
                if self.id == 2805 or self.id == 2808 or self.id == 2809 or self.id == 11805 then
                    local number = 1
                elseif self.id == 51001 or self.id == 51019 or self.id == 51021 then
                    local number = 2
                elseif self.id == 4002 then
                    local number = 3
                elseif self.id == 53004 then
                    local number = 5
                elseif self.id == 48631 then
                else
                    local number = 4
                end
                if not person:get_quest_var("waterform:region" .. tostring(number)) then
                    person:set_quest_var("waterform", "region" .. tostring(number), 1)
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
                    person:advance_quest("waterform")
                end
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif actor:get_quest_stage("waterform") == 4 and (actor:has_item("2808") or actor:has_equipped("2808")) then
    -- switch on self.id
    if self.id == 2805 or self.id == 2808 or self.id == 2809 or self.id == 11805 then
        local number = 1
    elseif self.id == 51001 or self.id == 51019 or self.id == 51021 then
        local number = 2
    elseif self.id == 4002 then
        local number = 3
    elseif self.id == 53004 then
        local number = 5
    elseif self.id == 48631 then
    else
        local number = 4
    end
    if not actor:get_quest_var("waterform:region" .. tostring(number)) then
        actor:set_quest_var("waterform", "region" .. tostring(number), 1)
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
        actor:advance_quest("waterform")
    end
end