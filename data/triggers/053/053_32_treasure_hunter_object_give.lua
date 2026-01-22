-- Trigger: Treasure Hunter object give
-- Zone: 53, ID: 32
-- Type: OBJECT, Flags: GIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #5332

-- Converted from DG Script #5332: Treasure Hunter object give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
-- switch on self.id
if self.id == 61514 then
    -- singing chain
    local stage = 1
elseif self.id == 4319 then
    -- fire ring
    local stage = 2
elseif self.id == 16103 then
    -- sandstone ring
    local stage = 3
elseif self.id == 50215 then
    -- electrum hoop
    local stage = 4
elseif self.id == 48101 then
    -- rainbow shell
    local stage = 5
elseif self.id == 16009 then
    -- stormshield
    local stage = 6
elseif self.id == 55008 then
    -- snow leopard cloak
    local stage = 7
elseif self.id == 49041 then
    -- rope ladder
    local stage = 8
elseif self.id == 58401 then
    -- phoenix feather
    local stage = 9
elseif self.id == 53500 or self.id == 53501 or self.id == 53505 or self.id == 53506 then
    -- sleet armor
    local stage = 10
end
local person = victim
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("treasure_hunter") == "stage" and person:get_quest_var("treasure_hunter:hunt") == "running" then
            -- switch on self.id
            if self.id == 61514 then
                -- singing chain
                local stage = 1
                local variable = person:get_has_completed("enchanted_hollow_quest")
            elseif self.id == 4319 then
                -- fire ring
                local stage = 2
                local variable = person:get_quest_var("theatre:fire_ring")
            elseif self.id == 16103 then
                -- sandstone ring
                local stage = 3
                local variable = person:get_quest_var("desert_quest:scorpion")
            elseif self.id == 50215 then
                -- electrum hoop
                local stage = 4
                local variable = person:get_has_completed("bayou_quest")
            elseif self.id == 48101 then
                -- rainbow shell
                local stage = 5
                local variable = person:get_quest_var("fieryisle_quest:shell")
            elseif self.id == 16009 then
                -- stormshield
                local stage = 6
                if person:get_quest_var("mystwatch_quest:step") == "complete" then
                    local variable = 1
                end
            elseif self.id == 55008 then
                -- snow leopard cloak
                local stage = 7
                local variable = person:get_quest_var("tech_mysteries_quest:cloak")
            elseif self.id == 49041 then
                -- rope ladder
                local stage = 8
                local variable = person:get_quest_var("griffin_quest:ladder")
            elseif self.id == 58401 then
                -- phoenix feather
                local stage = 9
                local variable = person:get_quest_var("KoD_quest:feather")
            elseif self.id == 53500 or self.id == 53501 or self.id == 53505 or self.id == 53506 then
                -- sleet armor
                local stage = 10
                local variable = person:get_quest_var("frost_valley_quest:elf")
            end
            if variable then
                person:set_quest_var("treasure_hunter", "hunt", "found")
                person:send("<b:yellow>You have found the treasure!</>")
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end