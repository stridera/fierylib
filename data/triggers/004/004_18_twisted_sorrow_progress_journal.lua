-- Trigger: Twisted Sorrow progress journal
-- Zone: 4, ID: 18
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 14 if statements
--
-- Original DG Script: #418

-- Converted from DG Script #418: Twisted Sorrow progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "twisted") or string.find(arg, "sorrow") or string.find(arg, "twisted_sorrow") or string.find(arg, "twisted") forest quest then
    _return_value = false
    actor:send("<b:green>&uTwisted Sorrow</>")
    actor:send("Recommended Level: 10")
    if actor:get_has_completed("twisted_sorrow") then
        local status = "Completed!"
    elseif actor:get_quest_stage("twisted_sorrow") then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    local luck = actor:get_quest_var("twisted_sorrow:satisfied_tree:12016")
    local reverence = actor:get_quest_var("twisted_sorrow:satisfied_tree:12017")
    local reliance = actor:get_quest_var("twisted_sorrow:satisfied_tree:12018")
    local nimbleness = actor:get_quest_var("twisted_sorrow:satisfied_tree:12014")
    local kindness = actor:get_quest_var("twisted_sorrow:satisfied_tree:12046")
    local tree1 = get_room("12016")
    local tree2 = get_room("12017")
    local tree3 = get_room("12018")
    local tree4 = get_room("12014")
    local tree5 = get_room("12046")
    if actor:get_quest_stage("twisted_sorrow") == 1 then
        actor:send("Quest Master: " .. tostring(mobiles.template(302, 14).name))
        actor:send("</>")
        actor:send("Bring drink to awaken the trees from the corruption.")
        if luck == 1 or reverence == 1 or reliance == 1 or nimbleness == 1 or kindness == 1 then
            actor:send("</>")
            actor:send("You have already awakened the following trees:")
            if luck == 1 then
                actor:send("- &9<blue>" .. tostring(tree1.name) .. "</>")
            end
            if reverence == 1 then
                actor:send("- &9<blue>" .. tostring(tree2.name) .. "</>")
            end
            if reliance == 1 then
                actor:send("- &9<blue>" .. tostring(tree3.name) .. "</>")
            end
            if nimbleness == 1 then
                actor:send("- &9<blue>" .. tostring(tree4.name) .. "</>")
            end
            if kindness == 1 then
                actor:send("- &9<blue>" .. tostring(tree5.name) .. "</>")
            end
        end
        actor:send("</>")
        actor:send("Offerings are still needed for:")
        if luck == 0 then
            actor:send("- <green>" .. tostring(tree1.name) .. "</>")
        end
        if reverence == 0 then
            actor:send("- <green>" .. tostring(tree2.name) .. "</>")
        end
        if reliance == 0 then
            actor:send("- <green>" .. tostring(tree3.name) .. "</>")
        end
        if nimbleness == 0 then
            actor:send("- <green>" .. tostring(tree4.name) .. "</>")
        end
        if kindness == 0 then
            actor:send("- <green>" .. tostring(tree5.name) .. "</>")
        end
        actor:send("</>")
        actor:send("Say \"follow me\" to the hooded druid when you have an offering to present.")
    end
end
return _return_value