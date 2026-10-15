-- Trigger: Pyromancer Subclass progress journal
-- Zone: 4, ID: 64
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #464

-- Converted from DG Script #464: Pyromancer Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local pyroraces = "arborean dragonborn_frost"
    if string.find(arg, "Pyromancer") and string.find(actor.class, "sorcerer") and actor.level <= 45 and not (string.find(pyroraces, actor.race)) then
        _return_value = true
        actor:send("<b:red>Pyromancer</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(52, 30).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("pyromancer_subclass") > 0 then
            actor:send(tostring(mobiles.template(52, 30).name) .. " said to you:")
            -- switch on actor:get_quest_stage("pyromancer_subclass")
            do
                local _sw1 = string.lower(tostring(actor:get_quest_stage("pyromancer_subclass") or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Only the best and most motivated of mages will complete the quest I lay before you._")
                    actor:send("However, I am sure it is in you, if it is truly your desire, to complete this quest and become a pyromancer.")
                elseif tonumber(_sw1) == 2 then
                    actor:send("Part of the essence of fire is no longer under my power.")
                    actor:send("I once controlled all three parts of the flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>._")
                    actor:send("But one of them was taken from my control.")
                elseif tonumber(_sw1) == 3 or tonumber(_sw1) == 4 then
                    actor:send("The " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame was taken from me._")
                    actor:send("To truly help, I suggest you stop loitering and go recover it.'")
                    -- switch on actor:get_quest_var("pyromancer_subclass:part")
                    local place
                    do
                        local _sw2 = string.lower(tostring(actor:get_quest_var("pyromancer_subclass:part") or ""))
                        if _sw2 == "white" then
                            place = "&bin some kind of mine&0"
                        elseif _sw2 == "black" then
                            place = "&bin some kind of temple&0"
                        else
                            place = "&bnear some kind of hill&0"
                        end
                    end
                    actor:send("Last I heard, it was " .. tostring(place) .. ", or something of the like.")
                end
            end
        end
    end
end
return _return_value