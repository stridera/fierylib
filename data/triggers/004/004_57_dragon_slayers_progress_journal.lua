-- Trigger: Dragon Slayers progress journal
-- Zone: 4, ID: 57
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #457

-- Converted from DG Script #457: Dragon Slayers progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "dragon_slayers") or string.find(arg, "slayers") or string.find(arg, "slayer") or string.find(arg, "dragon") slayer or string.find(arg, "dragon") slayers then
    _return_value = false
    local stage = actor:get_quest_stage("dragon_slayer")
    local master = mobiles.template(30, 80).name
    local hunt = actor:get_quest_var("dragon_slayer:hunt")
    local target1 = actor:get_quest_var("dragon_slayer:target1")
    actor:send("<b:green>&uDragon Slayers</>")
    -- switch on stage
    if stage == 1 then
        local victim1 = "a dragon hedge"
    elseif stage == 2 then
        local victim1 = "the green wyrmling"
    elseif stage == 3 then
        local victim1 = "Wug the Fiery Drakling"
    elseif stage == 4 then
        local victim1 = "the young blue dragon"
    elseif stage == 5 then
        local victim1 = "a faerie dragon"
    elseif stage == 6 then
        local victim1 = "the wyvern"
    elseif stage == 7 then
        local victim1 = "an ice lizard"
    elseif stage == 8 then
        local victim1 = "the Beast of Borgan"
    elseif stage == 9 then
        local victim1 = "Tri-Aszp"
    elseif stage == 10 then
        local victim1 = "the Hydra"
    end
    if stage == 1 or not stage then
        local level = 5
    else
        local level = (stage - 1) * 10
    end
    if not actor:get_has_completed("dragon_slayer") then
        actor:send("Minimum Level: " .. tostring(level))
    end
    if actor:get_has_completed("dragon_slayer") then
        local status = "Completed!"
    elseif stage then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    if stage > 0 and not actor:get_has_completed("dragon_slayer") then
        if actor.level >= level then
            actor:send("Quest Master: " .. tostring(master))
            if hunt == "dead" or hunt == "running" then
                actor:send("You have a contract for the death of " .. tostring(victim1) .. ".")
                if hunt == "dead" then
                    actor:send("You have completed the hunt.")
                    actor:send("Return the notice to " .. tostring(master) .. " for your reward!")
                end
            end
        end
    end
end
return _return_value