-- Trigger: Ranger Druid Subclass progress journal
-- Zone: 4, ID: 68
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #468

-- Converted from DG Script #468: Ranger Druid Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local druidraces = "none"
    local rangerraces = "none"
    if string.find(arg, "Ranger") and string.find(actor.class, "Warrior") and actor.level <= 25 and not (string.find(rangerraces, "actor.race")) then
        actor:send("<b:green>Ranger</>")
        local check = "yes"
    elseif string.find(arg, "Druid") and string.find(actor.class, "Cleric") and actor.level <= 35 and not (string.find(druidraces, "actor.race")) then
        actor:send("<green>Druid</>")
        local check = "yes"
    end
    if string.find(check, "yes") then
        _return_value = false
        actor:send("Quest Master: " .. tostring(mobiles.template(163, 15).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if string.find(arg, "Ranger") then
            actor:send("This class is for good characters only.")
        else
            actor:send("This class is for neutral characters only.")
        end
        if actor:get_quest_stage("ran_dru_subclass") then
            actor:send(tostring(mobiles.template(163, 15).name) .. " said to you:")
            -- switch on actor:get_quest_stage("ran_dru_subclass")
            if actor:get_quest_stage("ran_dru_subclass") == 1 then
                actor:send("Only the most dedicated to the forests shall complete the quest I set upon you.")
            elseif actor:get_quest_stage("ran_dru_subclass") == 2 then
                actor:send("Yes, quest. I do suppose it would help if I told you about it._")
                actor:send("Long ago I lost something.")
                actor:send("It is a shame, but it has never been recovered._")
                actor:send("If you were to help me with that, then we could arrange something.")
            elseif actor:get_quest_stage("ran_dru_subclass") == 3 or actor:get_quest_stage("ran_dru_subclass") == 4 then
                actor:send("It seems I am becoming forgetful in my age._")
                actor:send("Well, you see now, I lost the jewel of my heart.")
                actor:send("If you are up to it, finding and returning it to me will get you your reward._")
                actor:send("But for now, it is time for you to depart I think._")
                actor:send("You have brought up painful memories for me to relive.")
            end
        end
    end
end
return _return_value