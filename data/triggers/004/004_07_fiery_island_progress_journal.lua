-- Trigger: Fiery Island Progress journal
-- Zone: 4, ID: 7
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #407

-- Converted from DG Script #407: Fiery Island Progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "liberate") or string.find(arg, "fiery") or string.find(arg, "liberate_fiery_island") or string.find(arg, "fieryisle_quest") or string.find(arg, "fieryisle") or string.find(arg, "liberate_fiery_island") or string.find(arg, "fiery_isle") or string.find(arg, "fiery_island_quest") then
    if actor.level >= 35 then
        _return_value = false
        local stage = actor:get_quest_stage("fieryisle_quest")
        actor:send("<b:green>&uLiberate Fiery Island</>")
        actor:send("Recommended Level: 55")
        actor:send("Initial rewards can be received at level 35.")
        if actor:get_has_completed("fieryisle_quest") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("fieryisle_quest") then
            actor:send("Quest Master: the island shaman")
            actor:send("</>")
            actor:send("You are trying to:")
            -- switch on stage
            if stage == 1 then
                actor:send("Enter the volcano and find the warlord's son.")
            elseif stage == 2 then
                actor:send("Find the dwarrow woman and ask for a spell of reversal.")
            elseif stage == 3 then
                actor:send("Kill the ash lord and retrieve his crown.")
            elseif stage == 4 then
                actor:send("Return the crown of the ash lord to the dwarrow woman.")
            elseif stage == 5 then
                actor:send("Find the person turned to rock and hold the spell the dwarrow woman gave you.")
            elseif stage == 6 then
                actor:send("Retrieve the ivory key.")
            elseif stage == 7 then
                actor:send("Find Vulcera in the ivory tower.")
            elseif stage == 8 then
                actor:send("Give the ivory key to Vulcera.")
            elseif stage == 9 then
                actor:send("Defeat Vulcera!")
            end
            actor:send("</>")
            if actor:get_quest_var("fieryisle_quest:chimera") then
                actor:send("The mystic phrase to open the volcano is <b:white>buntoi nakkarri karisto</>.")
            else
                actor:send("Defeat the guardian to learn the mystic phrase to open the volcano.")
            end
        end
    end
end
return _return_value