-- Trigger: Ice clarification
-- Zone: 4, ID: 74
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #474

-- Converted from DG Script #474: Ice clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "ice" then
    local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist Necromancer"
    if string.find(sorcererclasses, "actor.class") then
        _return_value = false
        actor:send("Please specify:")
        actor:send("Ice Wand")
        if string.find(actor.class, "Cryomancer") then
            if actor.level >= 50 then
                actor:send("Wall of Ice")
            end
            if actor.level >= 85 then
                actor:send("Ice Shards")
            end
        end
    end
end
return _return_value