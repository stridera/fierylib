-- Trigger: Beast Masters progress journal
-- Zone: 4, ID: 59
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #459

-- Converted from DG Script #459: Beast Masters progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "beast") or string.find(arg, "masters") or string.find(arg, "beast_masters") then
    _return_value = false
    local stage = actor:get_quest_stage("beast_master")
    local master = mobiles.template(53, 6).name
    local bounty = actor:get_quest_var("beast_master:hunt")
    local target1 = actor:get_quest_var("beast_master:target1")
    actor:send("<b:green>&uBeast Masters</>")
    -- switch on stage
    if stage == 1 then
        local victim1 = "an abominable slime creature"
    elseif stage == 2 then
        local victim1 = "a large buck"
    elseif stage == 3 then
        local victim1 = "the giant scorpion"
    elseif stage == 4 then
        local victim1 = "a monstrous canopy spider"
    elseif stage == 5 then
        local victim1 = "the chimera"
    elseif stage == 6 then
        local victim1 = "the drider king"
    elseif stage == 7 then
        local victim1 = "a beholder"
    elseif stage == 8 then
        local victim1 = "the Banshee"
    elseif stage == 9 then
        local victim1 = "Baba Yaga"
    elseif stage == 10 then
        local victim1 = "the medusa"
    end
    if stage == 1 or not stage then
        local level = 1
    else
        local level = (stage - 1) * 10
    end
    if not actor:get_has_completed("beast_master") then
        actor:send("Minimum Level: " .. tostring(level))
    end
    if actor:get_has_completed("beast_master") then
        local status = "Completed!"
    elseif stage then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    if stage > 0 and not actor:get_has_completed("bounty_hunt") then
        if actor.level >= level then
            actor:send("Quest Master: " .. tostring(master))
            if bounty == "running" or bounty == "dead" then
                actor:send("You have an assignment to slay " .. tostring(victim1) .. ".")
                if bounty == "dead" then
                    actor:send("You have completed the hunt.")
                    actor:send("Return your assignment to Pumahl for your reward!")
                end
            end
        end
    end
end
return _return_value