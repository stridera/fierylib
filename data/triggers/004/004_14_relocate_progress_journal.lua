-- Trigger: Relocate progress journal
-- Zone: 4, ID: 14
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #414

-- Converted from DG Script #414: Relocate progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "relocate") or string.find(arg, "relocate_spell_quest") then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if (string.find(relocateclasses, "actor.class")) and actor.level >= 60 then
        _return_value = false
        local stage = actor:get_quest_stage("relocate_spell_quest")
        actor:send("<b:green>&uRelocate</>")
        actor:send("Minimum Level: 65")
        if actor:get_has_completed("relocate_spell_quest") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("relocate_spell_quest") then
            local master1 = mobiles.template(492, 50).name in the Black Ice Desert
            local master2 = mobiles.template(492, 51).name
            -- switch on stage
            if stage == 1 or stage == 2 then
                local next = "the Staff of the Mystics"
                local place = "a druid hiding out beyond Anlun Vale"
                local master = master1
                if actor:get_quest_var("relocate_spell_quest:greet") == 0 then
                elseif stage == 3 or stage == 4 then
                    local next = "the Crystal Telescope"
                    local place = "an observer of the cold village"
                    local master = master1
                else
                    local next = "a glass globe"
                    local place = "the Valley of the Frost Elves"
                    local master = master2
                end
            elseif stage == 5 then
                local next = "the Crystal Telescope"
                local master = master1
            elseif stage == 6 then
                local next = "a silver-trimmed spellbook"
                local place = "a tower within a destroyed land"
                local master = master1
            elseif stage == 7 then
                local next = "a map"
                local place = "from a mapper in South Caelia"
                local master = master1
            elseif stage == 8 or stage == 9 then
                local next = "the Golden Quill"
                local place = "the forest near Baba Yaga's hut"
                local master = master1
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            if stage ~= 2 and stage ~= 4 and stage ~= 5 and stage ~= 9 then
                actor:send("You are trying to retrieve:")
                actor:send("<b:yellow>" .. tostring(next) .. "</> from <b:green>" .. tostring(place) .. ".</>")
            else
                actor:send("Return <b:yellow>" .. tostring(next) .. "</> to " .. tostring(master) .. ".")
            end
        end
    end
end
return _return_value