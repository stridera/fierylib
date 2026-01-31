-- Trigger: Phase mace dig trigger
-- Zone: 3, ID: 20
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #320

-- Converted from DG Script #320: Phase mace dig trigger
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: dig
if not (cmd == "dig") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "d" or cmd == "di" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("phase_mace") == 2 then
    if actor:get_quest_var("phase_mace:graves") == "done" then
        actor:send("<b:yellow>You have already completed your pilgrimage.</>")
    end
    local room = actor.room
    -- Graveyard*
    if room.id >= 47000 and room.id <= 47404 then
        local dig = "yes"
        local item = 18522
        local num = 3
        -- Cathedral*
    elseif room.id >= 8504 and room.id <= 8509 then
        local dig = "yes"
        local item = 18523
        local num = 4
        -- Pyramid*
    elseif room.id >= 16200 and room.id <= 16299 then
        local dig = "yes"
        local item = 18524
        local num = 5
        -- Barrow*
    elseif room.id >= 48000 and room.id <= 48099 then
        local dig = "yes"
        local num = 6
    end
    if dig == "yes" then
        actor:send("You dig up a handful of dirt.")
        self.room:spawn_object(185, 25)
        actor:set_quest_var("phase_mace", "dirt%num%", 1)
        actor:command("get dirt")
        local dirt3 = actor:get_quest_var("phase_mace:dirt3")
        local dirt4 = actor:get_quest_var("phase_mace:dirt4")
        local dirt5 = actor:get_quest_var("phase_mace:dirt5")
        local dirt6 = actor:get_quest_var("phase_mace:dirt6")
        if dirt3 and dirt4 and dirt5 and dirt6 then
            if not actor:get_quest_var("phase_mace:graves") then
                actor:send("<b:yellow>You have completed your pilgrimage.</>")
                actor:set_quest_var("phase_mace", "graves", "done")
            end
        end
    else
        actor:send("This isn't the proper place to dig for grave dirt.")
    end
else
    _return_value = false
end
return _return_value