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
    do
        local _sw1 = string.lower(tostring(stage or ""))
        if tonumber(_sw1) == 1 then
            victim1 = "a dragon hedge"
        elseif tonumber(_sw1) == 2 then
            victim1 = "the green wyrmling"
        elseif tonumber(_sw1) == 3 then
            victim1 = "Wug the Fiery Drakling"
        elseif tonumber(_sw1) == 4 then
            victim1 = "the young blue dragon"
        elseif tonumber(_sw1) == 5 then
            victim1 = "a faerie dragon"
        elseif tonumber(_sw1) == 6 then
            victim1 = "the wyvern"
        elseif tonumber(_sw1) == 7 then
            victim1 = "an ice lizard"
        elseif tonumber(_sw1) == 8 then
            victim1 = "the Beast of Borgan"
        elseif tonumber(_sw1) == 9 then
            victim1 = "Tri-Aszp"
        elseif tonumber(_sw1) == 10 then
            victim1 = "the Hydra"
        end
    end
    local level
    if stage == 1 or (stage or 0) == 0 then
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
    elseif (stage or 0) > 0 then
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