-- Trigger: burning wall
-- Zone: 482, ID: 50
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #48250

-- Converted from DG Script #48250: burning wall
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level < 100 then
    if string.find(direction, "south") then
        if string.find(actor.class, "Sorcerer") or string.find(actor.class, "Pyromancer") or actor:get_quest_stage("fire_wand") > 7 then
            actor:send("The flames and lava bend around you as you pass through unharmed.")
        else
            local damage = (random(1, 40) + 40)
            local damage_dealt = actor:damage(damage)  -- type: fire
            actor:send("The flames scorch you as you try to approach the wall. (" .. tostring(damage_dealt) .. ")")
            actor:send("You seem to hear a voice whisper, 'This room is not for you.'")
            _return_value = false
        end
    end
end
return _return_value