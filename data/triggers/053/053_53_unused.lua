-- Trigger: **UNUSED**
-- Zone: 53, ID: 53
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
-- TODO(parity): same `actor.room ~= "place"` bug as 053_48. **UNUSED**.
-- Full rewrite from DG #5353 if re-enabled.
--
-- Original DG Script: #5353

-- Converted from DG Script #5353: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- For Seed of Destruction on item 48037
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "m" or _sw1 == "me" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("monk_vision") >= 9 and actor:get_quest_stage("monk_chants") == 7 and actor.level == 99 and (actor.room.zone_id == 489 and actor.room.local_id == 13) then
    if actor:has_equipped(2, 199) then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send("<b:black>The chant to engender catastrophe echoes from the altar!</>")
            actor:send("<b:black>You have learned Seed of Destruction.</>")  -- typo: sent
            skills.set_level(actor, "seed of destruction", 1000)
            actor:complete_quest("monk_chants")
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value