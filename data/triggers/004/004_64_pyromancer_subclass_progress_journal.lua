-- Trigger: Pyromancer Subclass progress journal
-- Zone: 4, ID: 64
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #464

-- Converted from DG Script #464: Pyromancer Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local pyroraces = "arborean dragonborn_frost"
    if string.find(arg, "Pyromancer") and string.find(actor.class, "Sorcerer") and actor.level <= 45 and not (string.find(pyroraces, "actor.race")) then
        _return_value = false
        actor:send("<b:red>Pyromancer</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(52, 30).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("pyromancer_subclass") then
            actor:send(tostring(mobiles.template(52, 30).name) .. " said to you:")
            -- switch on actor:get_quest_stage("pyromancer_subclass")
            if actor:get_quest_stage("pyromancer_subclass") == 1 then
                actor:send("Only the best and most motivated of mages will complete the quest I lay before you._")
                actor:send("However, I am sure it is in you, if it is truly your desire, to complete this quest and become a pyromancer.")
            elseif actor:get_quest_stage("pyromancer_subclass") == 2 then
                actor:send("Part of the essence of fire is no longer under my power.")
                actor:send("I once controlled all three parts of the flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>._")
                actor:send("But one of them was taken from my control.")
            elseif actor:get_quest_stage("pyromancer_subclass") == 3 or actor:get_quest_stage("pyromancer_subclass") == 4 then
                actor:send("The " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame was taken from me._")
                actor:send("To truly help, I suggest you stop loitering and go recover it.'")
                -- switch on actor:get_quest_var("pyromancer_subclass:part")
                if actor:get_quest_var("pyromancer_subclass:part") == "white" then
                    local place = "&bin some kind of mine&0"
                elseif actor:get_quest_var("pyromancer_subclass:part") == "black" then
                    local place = "&bin some kind of temple&0"
                elseif actor:get_quest_var("pyromancer_subclass:part") == "gray" then
                else
                    local place = "&bnear some kind of hill&0"
                end
                actor:send("Last I heard, it was " .. tostring(place) .. ", or something of the like.")
            end
        end
    end
end  -- auto-close block
return _return_value