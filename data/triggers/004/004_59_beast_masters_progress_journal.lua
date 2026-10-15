-- Trigger: Beast Masters progress journal
-- Zone: 4, ID: 59
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #459

-- Converted from DG Script #459: Beast Masters progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "beast") or string.find(arg, "masters") or string.find(arg, "beast_masters") then
    _return_value = true
    local stage = actor:get_quest_stage("beast_master")
    local master = mobiles.template(53, 6).name
    local bounty = actor:get_quest_var("beast_master:hunt")
    local target1 = actor:get_quest_var("beast_master:target1")
    actor:send("<b:green>&uBeast Masters</>")
    -- switch on stage
    local victim1
    do
        local _sw1 = string.lower(tostring(stage or ""))
        if tonumber(_sw1) == 1 then
            victim1 = "an abominable slime creature"
        elseif tonumber(_sw1) == 2 then
            victim1 = "a large buck"
        elseif tonumber(_sw1) == 3 then
            victim1 = "the giant scorpion"
        elseif tonumber(_sw1) == 4 then
            victim1 = "a monstrous canopy spider"
        elseif tonumber(_sw1) == 5 then
            victim1 = "the chimera"
        elseif tonumber(_sw1) == 6 then
            victim1 = "the drider king"
        elseif tonumber(_sw1) == 7 then
            victim1 = "a beholder"
        elseif tonumber(_sw1) == 8 then
            victim1 = "the Banshee"
        elseif tonumber(_sw1) == 9 then
            victim1 = "Baba Yaga"
        elseif tonumber(_sw1) == 10 then
            victim1 = "the medusa"
        end
    end
    local level
    if stage == 1 or (stage or 0) == 0 then
        level = 1
    else
        level = (stage - 1) * 10
    end
    if not actor:get_has_completed("beast_master") then
        actor:send("Minimum Level: " .. tostring(level))
    end
    local status
    if actor:get_has_completed("beast_master") then
        status = "Completed!"
    elseif (stage or 0) > 0 then
        status = "In Progress"
    else
        status = "Not Started"
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