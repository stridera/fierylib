-- Trigger: Heroes for Hire quests
-- Zone: 4, ID: 3
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #403

-- Converted from DG Script #403: Heroes for Hire quests
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "heroes") or string.find(arg, "hire") then
    _return_value = false
    actor:send("<yellow>=========== HEROES FOR HIRE ===========</>")
    actor:send("These hired jobs provide some quick cash and good thrills with some of Ethilien's most iconic creatures.")
    actor:send("<b:yellow>[Look]</> at the key words in a quest title for your current status.")
    actor:send("<yellow>=======================================</>_")
    actor:send("<b:green>AVAILABLE QUESTS:</>_")
    actor:send("<b:green>&uBeast Masters</>")
    actor:send("Battle the most ferocious animals on Ethilien, mundane and magical alike.")
    actor:send("This quest spans from level 1 to 90.")
    if actor:get_has_completed("beast_master") then
        local status = "Completed!"
    elseif actor:get_quest_stage("bounty_hunt") then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uContract Killers</>")
    actor:send("Sow some chaos by taking out key figures across the world.")
    actor:send("This quest spans from level 1 to 90.")
    if actor:get_has_completed("bounty_hunt") then
        local status = "Completed!"
    elseif actor:get_quest_stage("bounty_hunt") then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uDragon Slayers</>")
    actor:send("Take on those most awe-inspiring of creatures: the dragons!")
    actor:send("This quest spans from level 5 to 90.")
    if actor:get_has_completed("dragon_slayer") then
        local status = "Completed!"
    elseif actor:get_quest_stage("dragon_slayer") then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uTreasure Hunter</>")
    actor:send("Delve deep for legendary treasures!")
    actor:send("This quest spans from level 1 to 90.")
    if actor:get_has_completed("treasure_hunter") then
        local status = "Completed!"
    elseif actor:get_quest_stage("treasure_hunter") then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uElemental Chaos</>")
    actor:send("Disperse the forces of Chaos and restore Balance to Ethilien.")
    actor:send("This quest spans from level 1 to 90.")
    if actor:get_has_completed("elemental_chaos") then
        local status = "Completed!"
    elseif actor:get_quest_stage("elemental_chaos") then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
end
return _return_value