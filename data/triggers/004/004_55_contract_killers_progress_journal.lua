-- Trigger: Contract Killers progress journal
-- Zone: 4, ID: 55
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--
-- Original DG Script: #455

-- Converted from DG Script #455: Contract Killers progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "contract") or string.find(arg, "killers") or string.find(arg, "bounty_hunt") or string.find(arg, "contract_killers") then
    _return_value = false
    local stage = actor:get_quest_stage("bounty_hunt")
    local master = mobiles.template(60, 51).name
    local bounty = actor:get_quest_var("bounty_hunt:bounty")
    local target1 = actor:get_quest_var("bounty_hunt:target1")
    local target2 = actor:get_quest_var("bounty_hunt:target2")
    local target3 = actor:get_quest_var("bounty_hunt:target3")
    actor:send("<b:green>&uContract Killers</>")
    -- switch on stage
    if stage == 1 then
        local victim1 = "the King of the Meer Cats"
    elseif stage == 2 then
        local victim1 = "the Noble"
        local victim2 = "the Abbot"
    elseif stage == 3 then
        local victim1 = "the O'Connor Chieftain"
        local victim2 = "the McLeod Chieftain"
        local victim3 = "the Cameron Chieftain"
    elseif stage == 4 then
        local victim1 = "the Frakati Leader"
    elseif stage == 5 then
        local victim1 = "Cyrus"
    elseif stage == 6 then
        local victim1 = "Lord Venth"
    elseif stage == 7 then
        local victim1 = "the high druid of Anlun Vale"
    elseif stage == 8 then
        local victim1 = "the Lizard King"
    elseif stage == 9 then
        local victim1 = "Sorcha"
    elseif stage == 10 then
        local victim1 = "the Goblin King"
    end
    if stage == 1 or not stage then
        local level = 1
    else
        local level = (stage - 1) * 10
    end
    if not actor:get_has_completed("bounty_hunt") then
        actor:send("Minimum Level: " .. tostring(level))
    end
    if actor:get_has_completed("bounty_hunt") then
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
                if stage ~= 2 and stage ~= 3 then
                    actor:send("You have a contract for the death of " .. tostring(victim1) .. ".")
                elseif stage == 2 then
                    actor:send("You have a contract for the death of " .. tostring(victim1) .. " and " .. tostring(victim2) .. ".")
                elseif stage == 3 then
                    actor:send("You have a contract for the death of " .. tostring(victim1) .. ", " .. tostring(victim2) .. ", and " .. tostring(victim3) .. ".")
                end
                if bounty == "dead" then
                    actor:send("You have completed the contract.")
                    actor:send("Return it to " .. tostring(master) .. " for your payment!")
                elseif stage == 2 then
                    if target1 then
                        actor:send("You have scratched " .. tostring(victim1) .. " off the list.")
                    end
                    if target2 then
                        actor:send("You have scratched " .. tostring(victim2) .. " off the list.")
                    end
                elseif stage == 3 then
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
            end
        end
    end
end
return _return_value