-- Trigger: Elemental Chaos progress journal
-- Zone: 5, ID: 0
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 13 if statements
--
-- Original DG Script: #500

-- Converted from DG Script #500: Elemental Chaos progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "elemental_chaos") or string.find(arg, "elemental") or string.find(arg, "chaos") or string.find(arg, "elemental chaos") then
    _return_value = false
    local stage = actor:get_quest_stage("elemental_chaos")
    local master = mobiles.template(53, 8).name
    local hunt = actor:get_quest_var("elemental_chaos:bounty")
    local target1 = actor:get_quest_var("elemental_chaos:target1")
    local target2 = actor:get_quest_var("elemental_chaos:target2")
    local target3 = actor:get_quest_var("elemental_chaos:target3")
    actor:send("<b:green>&uElemental Chaos</>")
    -- switch on actor:get_quest_stage("elemental_chaos")
    if actor:get_quest_stage("elemental_chaos") == 1 then
        local mission = "investigate the news of an imp and dispatch it if you find one"
    elseif actor:get_quest_stage("elemental_chaos") == 2 then
        local mission = "silence the seductive song of the Leading Player"
    elseif actor:get_quest_stage("elemental_chaos") == 3 then
        local mission = "destroy the Chaos and the cult worshipping it"
    elseif actor:get_quest_stage("elemental_chaos") == 4 then
        local mission = "undertake the vision quest from the shaman in Three-Falls Canyon and defeat whatever awaits at the end"
    elseif actor:get_quest_stage("elemental_chaos") == 5 then
        local mission = "dispatch the Fangs of Yeenoghu.  Be sure to destroy all of them"
        local victim1 = "the shaman Fang of Yeenoghu"
        local victim2 = "the necromancer Fang of Yeenoghu"
        local victim3 = "the diabolist Fang of Yeenoghu"
    elseif actor:get_quest_stage("elemental_chaos") == 6 then
        local mission = "extinguish the fire elemental lord who serves Krisenna"
    elseif actor:get_quest_stage("elemental_chaos") == 7 then
        local mission = "stop the acolytes in the Cathedral of Betrayal"
    elseif actor:get_quest_stage("elemental_chaos") == 8 then
        local mission = "destroy Cyprianum the Reaper in the heart of his maze"
    elseif actor:get_quest_stage("elemental_chaos") == 9 then
        local mission = "banish the Chaos Demon in Frost Valley"
    elseif actor:get_quest_stage("elemental_chaos") == 10 then
        local mission = "slay one of the Norhamen"
    end
    if stage == 1 then
        local level = 1
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
    if stage > 0 and not actor:get_has_completed("elemental_chaos") then
        if actor.level >= level then
            actor:send("Quest Master: " .. tostring(master))
            if hunt == "running" or hunt == "dead" then
                actor:send("You have a mission to " .. tostring(mission) .. ".")
                if hunt == "dead" then
                    actor:send("You have completed the mission.")
                    actor:send("Return it to " .. tostring(master) .. "!")
                elseif stage == 5 then
                    if target1 then
                        actor:send("You have scratched " .. tostring(victim1) .. " off the list.")
                    end
                    if target2 then
                        actor:send("You have scratched " .. tostring(victim2) .. " off the list.")
                    end
                    if target3 then
                        actor:send("You have scratched " .. tostring(victim3) .. " off the list.")
                    end
                end
            else
                actor:send("Report to Hakujo for further news.")
            end
        end
    end
end
return _return_value