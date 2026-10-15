-- Trigger: Treasure Hunter object give
-- Zone: 53, ID: 32
-- Type: OBJECT, Flags: GIVE
-- Status: NEEDS_REVIEW
-- TODO(parity): same problems as 053_24 (the GET-equivalent of this
-- GIVE trigger): branch-scoped `stage`/`variable`, group-iter `a`
-- branch-scoped, `== "stage"` string compare, legacy 5-digit ids. Full
-- rewrite from DG #5332.
--
-- Original DG Script: #5332

-- Converted from DG Script #5332: Treasure Hunter object give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
-- switch on self.id
if (self.zone_id == 615 and self.id == 14) then
    -- singing chain
    local stage = 1
elseif (self.zone_id == 43 and self.id == 19) then
    -- fire ring
    local stage = 2
elseif (self.zone_id == 161 and self.id == 3) then
    -- sandstone ring
    local stage = 3
elseif (self.zone_id == 502 and self.id == 15) then
    -- electrum hoop
    local stage = 4
elseif (self.zone_id == 481 and self.id == 1) then
    -- rainbow shell
    local stage = 5
elseif (self.zone_id == 160 and self.id == 9) then
    -- stormshield
    local stage = 6
elseif (self.zone_id == 550 and self.id == 8) then
    -- snow leopard cloak
    local stage = 7
elseif (self.zone_id == 490 and self.id == 41) then
    -- rope ladder
    local stage = 8
elseif (self.zone_id == 584 and self.id == 1) then
    -- phoenix feather
    local stage = 9
elseif (self.zone_id == 534 and self.id == 100) or (self.zone_id == 534 and self.id == 101) or (self.zone_id == 534 and self.id == 105) or (self.zone_id == 534 and self.id == 106) then
    -- sleet armor
    local stage = 10
end
local person = victim
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("treasure_hunter") == "stage" and person:get_quest_var("treasure_hunter:hunt") == "running" then
            -- switch on self.id
            local variable
            if (self.zone_id == 615 and self.id == 14) then
                -- singing chain
                local stage = 1
                variable = person:get_has_completed("enchanted_hollow_quest")
            elseif (self.zone_id == 43 and self.id == 19) then
                -- fire ring
                local stage = 2
                variable = person:get_quest_var("theatre:fire_ring")
            elseif (self.zone_id == 161 and self.id == 3) then
                -- sandstone ring
                local stage = 3
                variable = person:get_quest_var("desert_quest:scorpion")
            elseif (self.zone_id == 502 and self.id == 15) then
                -- electrum hoop
                local stage = 4
                variable = person:get_has_completed("bayou_quest")
            elseif (self.zone_id == 481 and self.id == 1) then
                -- rainbow shell
                local stage = 5
                variable = person:get_quest_var("fieryisle_quest:shell")
            elseif (self.zone_id == 160 and self.id == 9) then
                -- stormshield
                local stage = 6
                if person:get_quest_var("mystwatch_quest:step") == "complete" then
                    variable = 1
                end
            elseif (self.zone_id == 550 and self.id == 8) then
                -- snow leopard cloak
                local stage = 7
                variable = person:get_quest_var("tech_mysteries_quest:cloak")
            elseif (self.zone_id == 490 and self.id == 41) then
                -- rope ladder
                local stage = 8
                variable = person:get_quest_var("griffin_quest:ladder")
            elseif (self.zone_id == 584 and self.id == 1) then
                -- phoenix feather
                local stage = 9
                variable = person:get_quest_var("kod_quest:feather")
            elseif (self.zone_id == 534 and self.id == 100) or (self.zone_id == 534 and self.id == 101) or (self.zone_id == 534 and self.id == 105) or (self.zone_id == 534 and self.id == 106) then
                -- sleet armor
                local stage = 10
                variable = person:get_quest_var("frost_valley_quest:elf")
            end
            if variable then
                person:set_quest_var("treasure_hunter", "hunt", "found")
                person:send("<b:yellow>You have found the treasure!</>")
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end