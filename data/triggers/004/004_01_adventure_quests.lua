-- Trigger: Adventure quests
-- Zone: 4, ID: 1
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #401

-- Converted from DG Script #401: Adventure quests
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "adventure") or string.find(arg, "adventures") then
    _return_value = true
    actor:send("<yellow>=========== ADVENTURE QUESTS ========<==/>")
    actor:send("Adventure is waiting!")
    actor:send("Explore the regions of Ethilien.")
    actor:send("Fight epic monsters, earn legendary rewards, and increase your might.")
    actor:send("<b:yellow>[Look]</> at the key words in a quest title for your current status.")
    actor:send("<yellow>=====================================<==/>_")
    actor:send("<b:green>AVAILABLE QUESTS:</>_")
    actor:send("<b:green>&uTwisted Sorrow</>")
    actor:send("Can you heal the sorrows of the Twisted Forest?")
    actor:send("Recommended Level: 10")
    local status
    if actor:get_has_completed("twisted_sorrow") then
        status = "Completed!"
    elseif actor:get_quest_stage("twisted_sorrow") then
        status = "In Progress"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uCombat in Eldoria</>")
    actor:send("The Third Black Legion and the Eldorian Guard, along with their allies in Split Skull and the Abbey, are locked in eternal warfare.")
    actor:send("Characters may align themselves with the forces of good or the forces of evil.")
    actor:send("But beware, once made that decision cannot be changed!")
    actor:send("Minimum Level: 10")
    local status
    if actor:get_quest_stage("black_legion") then
        status = "Continuous"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uThe Finale</>")
    actor:send("Defeat wild monkeys, recover keys, and help the theatre troupe perform their fiery Finale!")
    actor:send("Recommended Level: 10")
    local status
    if actor:get_quest_stage("theatre") then
        status = "Repeatable"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    if actor.level >= 10 then
        actor:send("<b:green>&uThe Horrors of Nukreth Spire</>")
        actor:send("Slay the gnolls of Nukreth Spire and liberate their captives.")
        actor:send("Multiple outcomes and multiple rewards await!")
        actor:send("This quest is infinitely repeatable.")
        actor:send("Recommended Level: 20")
        local status
        if actor:get_quest_stage("nukreth_spire") then
            status = "Repeatable"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 35 then
        actor:send("<b:green>&uLiberate Fiery Island</>")
        actor:send("Save Fiery Island from the usurping demigod.")
        actor:send("Minimum Level: 55")
        actor:send("- Some rewards can be received starting at level 35.")
        local status
        if actor:get_has_completed("fieryisle_quest") then
            status = "Completed!"
        elseif actor:get_quest_stage("fieryisle_quest") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 30 then
        actor:send("<b:green>&uTower in the Wastes</>")
        actor:send("Help the injured halfling find his brother!")
        actor:send("Recommended Level: 40")
        local status
        if actor:get_has_completed("krisenna_quest") then
            status = "Completed!"
        elseif actor:get_quest_stage("krisenna_quest") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 35 then
        actor:send("<b:green>&uSiege Mystwatch Fortress</>")
        actor:send("The dead fortify their position just outside the town of Mielikki.")
        actor:send("Stop them before they can invade!")
        actor:send("Recommended Level: 45")
        local status
        if actor:get_quest_stage("mystwatch_quest") then
            status = "Repeatable"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 45 then
        actor:send("<b:green>&uDestroy the Cult of the Griffin</>")
        actor:send("A sect of griffin-worshiping cultists has invaded a druid enclave in the middle of the Arabel Ocean.")
        actor:send("Smash the cult before they achieve their nefarious goals!")
        actor:send("Recommended Level: 60")
        local status
        if actor:get_has_completed("griffin_quest") then
            status = "Completed!"
        elseif actor:get_quest_stage("griffin_quest") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 85 then
        actor:send("<b:green>&uThe Planes of Doom</>")
        actor:send("Prepare yourself to leave the Prime Material Plane for the elemental planes!")
        actor:send("This quest begins your voyage through the outer planes to banish Lokari, God of the Moonless night.")
        actor:send("Minimum Level: 85")
        actor:send("- This quest begins a storyline intended for characters of level 95+")
        local status
        if actor:get_has_completed("doom_entrance") then
            status = "Completed!"
        elseif actor:get_quest_stage("doom_entrance") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
end
return _return_value