-- Trigger: Berserker Subclass progress journal
-- Zone: 4, ID: 70
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): contains literal DG remnants like %get.obj_shortdesc[...]% that the converter left as raw text inside actor:send(...) calls. These need to be rewritten as proper Lua splices using objects.template(zone, id).name and actor:get_quest_var(...) before players see correct output.
--
-- Original DG Script: #470

-- Converted from DG Script #470: Berserker Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local berserkerraces = "none"
    if string.find(arg, "Berserker") and string.find(actor.class, "warrior") and actor.level <= 25 and not (string.find(berserkerraces, actor.race)) then
        _return_value = true
        actor:send("<b:black>Berserker</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(364, 30).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("berserker_subclass") > 0 then
            actor:send(tostring(mobiles.template(364, 30).name) .. " said to you:")
            -- switch on actor:get_quest_stage("berserker_subclass")
            do
                local _sw1 = string.lower(tostring(actor:get_quest_stage("berserker_subclass") or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("There are a few shared rites that bind us together.")
                    actor:send("None is more revered than the Wild Hunt.")
                elseif tonumber(_sw1) == 2 then
                    actor:send("Let us challenge the Spirits for the right to prove ourselves!")
                    actor:send("If they deem you worthy, the Spirits send you a vision of a mighty beast.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("Howl to the spirits before " .. tostring(mobiles.template(364, 30).name) .. " and make your song known!")
                elseif tonumber(_sw1) == 4 then
                    -- switch on actor:get_quest_var("berserker_subclass:target")
                    local target
                    local place
                    do
                        local _sw2 = string.lower(tostring(actor:get_quest_var("berserker_subclass:target") or ""))
                        if tonumber(_sw2) == 16105 then
                            target = 16105
                            place = "a desert cave"
                        elseif tonumber(_sw2) == 16310 then
                            target = 16310
                            place = "some forested highlands"
                        elseif tonumber(_sw2) == 20311 then
                            target = 20311
                            place = "a vast plain"
                        elseif tonumber(_sw2) == 55220 then
                            target = 55220
                            place = "the frozen tundra"
                        end
                    end
                    actor:send("The Spirits revealed to you a vision of " .. "%get.mob_shortdesc[%target%]%!")
                    actor:send("You saw it iss in " .. tostring(place) .. "!")
                end
            end
        end
    end
end
return _return_value