-- Trigger: Berserker Subclass progress journal
-- Zone: 4, ID: 70
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): contains literal DG remnants like %get.obj_shortdesc[...]% or %actor.quest_variable[...]% that the converter left as raw text inside actor:send(...) calls. These need to be rewritten as proper Lua splices using objects.template(zone, id).name and actor:get_quest_var(...) before players see correct output.
--
-- Original DG Script: #470

-- Converted from DG Script #470: Berserker Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local berserkerraces = "none"
    if string.find(arg, "Berserker") and string.find(actor.class, "Warrior") and actor.level <= 25 and not (string.find(berserkerraces, actor.race)) then
        _return_value = true
        actor:send("&9<blue>Berserker</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(364, 30).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("berserker_subclass") then
            actor:send(tostring(mobiles.template(364, 30).name) .. " said to you:")
            -- switch on actor:get_quest_stage("berserker_subclass")
            if actor:get_quest_stage("berserker_subclass") == 1 then
                actor:send("There are a few shared rites that bind us together.")
                actor:send("None is more revered than the Wild Hunt.")
            elseif actor:get_quest_stage("berserker_subclass") == 2 then
                actor:send("Let us challenge the Spirits for the right to prove ourselves!")
                actor:send("If they deem you worthy, the Spirits send you a vision of a mighty beast.")
            elseif actor:get_quest_stage("berserker_subclass") == 3 then
                actor:send("Howl to the spirits before " .. tostring(mobiles.template(364, 30).name) .. " and make your song known!")
                -- switch on actor:get_quest_var("berserker_subclass:target")
                local target
                local place
                if actor:get_quest_var("berserker_subclass:target") == 16105 then
                    target = 16105
                    place = "a desert cave"
                elseif actor:get_quest_var("berserker_subclass:target") == 16310 then
                    target = 16310
                    place = "some forested highlands"
                elseif actor:get_quest_var("berserker_subclass:target") == 20311 then
                    target = 20311
                    place = "a vast plain"
                elseif actor:get_quest_var("berserker_subclass:target") == 55220 then
                    target = 55220
                    place = "the frozen tundra"
                end
                actor:send("The Spirits revealed to you a vision of " .. "%get.mob_shortdesc[%target%]%!")
                actor:send("You saw it iss in " .. tostring(place) .. "!")
            end
        end
    end
end  -- auto-close block
return _return_value