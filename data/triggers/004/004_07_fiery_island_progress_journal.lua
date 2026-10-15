-- Trigger: Fiery Island Progress journal
-- Zone: 4, ID: 7
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #407

-- Converted from DG Script #407: Fiery Island Progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "liberate") or string.find(arg, "fiery") or string.find(arg, "liberate fiery island") or string.find(arg, "fieryisle_quest") or string.find(arg, "fieryisle") or string.find(arg, "liberate_fiery_island") or string.find(arg, "fiery_isle") or string.find(arg, "fiery island quest") then
    if actor.level >= 35 then
        _return_value = true
        local stage = actor:get_quest_stage("fieryisle_quest")
        actor:send("<b:u:green>Liberate Fiery Island</>")
        actor:send("Recommended Level: 55")
        actor:send("Initial rewards can be received at level 35.")
        local status
        if actor:get_has_completed("fieryisle_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("fieryisle_quest") then
            actor:send("Quest Master: the island shaman")
            actor:send("</>")
            actor:send("You are trying to:")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Enter the volcano and find the warlord's son.")
                elseif tonumber(_sw1) == 2 then
                    actor:send("Find the dwarrow woman and ask for a spell of reversal.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("Kill the ash lord and retrieve his crown.")
                elseif tonumber(_sw1) == 4 then
                    actor:send("Return the crown of the ash lord to the dwarrow woman.")
                elseif tonumber(_sw1) == 5 then
                    actor:send("Find the person turned to rock and hold the spell the dwarrow woman gave you.")
                elseif tonumber(_sw1) == 6 then
                    actor:send("Retrieve the ivory key.")
                elseif tonumber(_sw1) == 7 then
                    actor:send("Find Vulcera in the ivory tower.")
                elseif tonumber(_sw1) == 8 then
                    actor:send("Give the ivory key to Vulcera.")
                elseif tonumber(_sw1) == 9 then
                    actor:send("Defeat Vulcera!")
                end
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