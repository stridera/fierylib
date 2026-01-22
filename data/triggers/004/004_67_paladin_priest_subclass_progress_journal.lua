-- Trigger: Paladin Priest Subclass progress journal
-- Zone: 4, ID: 67
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #467

-- Converted from DG Script #467: Paladin Priest Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local priestraces = "drow faerie_unseelie"
    local paladinraces = "drow faerie_unseelie"
    if string.find(arg, "Paladin") and string.find(actor.class, "Warrior") and actor.level <= 25 and not (string.find(paladinraces, "actor.race")) then
        actor:send("<b:white>Paladin</>")
        local check = "yes"
    elseif string.find(arg, "Priest") and string.find(actor.class, "Cleric") and actor.level <= 35 and not (string.find(priestraces, "actor.race")) then
        actor:send("<b:cyan>Priest</>")
        local check = "yes"
    end
    if string.find(check, "yes") then
        _return_value = false
        actor:send("Quest Master: " .. tostring(mobiles.template(185, 81).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        actor:send("This class is for good characters only.")
        if actor:get_quest_stage("pri_pal_subclass") then
            actor:send(tostring(mobiles.template(185, 81).name) .. " said to you:")
            -- switch on actor:get_quest_stage("pri_pal_subclass")
            if actor:get_quest_stage("pri_pal_subclass") == 1 then
                actor:send("It is necessary to make a quest such as this quite tough to ensure you really want to do this._")
                actor:send("I am sure you will complete the quest though.")
            elseif actor:get_quest_stage("pri_pal_subclass") == 2 then
                actor:send("One of our guests made off with our most sacred bronze chalice._")
                actor:send("We have reason to believe it was a ruse by the filthy diabolists to try and weaken us.")
                actor:send("</>Our Prior has offered to try and retrieve it for us, but..._")
                actor:send("I think perhaps that would be a bad idea and that you should find it instead.")
            elseif actor:get_quest_stage("pri_pal_subclass") == 3 then
                actor:send("Have you found the bronze chalice the diabolists stole?")
            end
        end
    end
end
return _return_value