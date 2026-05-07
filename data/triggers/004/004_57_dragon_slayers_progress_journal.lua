-- Trigger: Dragon Slayers progress journal
-- Zone: 4, ID: 57
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #457

-- Converted from DG Script #457: Dragon Slayers progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "dragon_slayers") or string.find(arg, "slayers") or string.find(arg, "slayer") or string.find(arg, "dragon slayer") or string.find(arg, "dragon slayers") then
    _return_value = true
    local stage = actor:get_quest_stage("dragon_slayer")
    local master = mobiles.template(30, 80).name
    local hunt = actor:get_quest_var("dragon_slayer:hunt")
    local target1 = actor:get_quest_var("dragon_slayer:target1")
    actor:send("<b:green>&uDragon Slayers</>")
    -- switch on stage
    local victim1
    if stage == 1 then
        victim1 = "a dragon hedge"
    elseif stage == 2 then
        victim1 = "the green wyrmling"
    elseif stage == 3 then
        victim1 = "Wug the Fiery Drakling"
    elseif stage == 4 then
        victim1 = "the young blue dragon"
    elseif stage == 5 then
        victim1 = "a faerie dragon"
    elseif stage == 6 then
        victim1 = "the wyvern"
    elseif stage == 7 then
        victim1 = "an ice lizard"
    elseif stage == 8 then
        victim1 = "the Beast of Borgan"
    elseif stage == 9 then
        victim1 = "Tri-Aszp"
    elseif stage == 10 then
        victim1 = "the Hydra"
    end
    local level
    if stage == 1 or not stage then
        level = 5
    else
        level = (stage - 1) * 10
    end
    if not actor:get_has_completed("dragon_slayer") then
        actor:send("Minimum Level: " .. tostring(level))
    end
    local status
    if actor:get_has_completed("dragon_slayer") then
        status = "Completed!"
    elseif stage then
        status = "In Progress"
    else
        status = "Not Started"
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