-- Trigger: Major clarification
-- Zone: 4, ID: 76
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #476

-- Converted from DG Script #476: Major clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "major" then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if (actor.level >= 50 and string.find(relocateclasses, "actor.class")) or (actor.level >= 65 and string.find(actor.class, "Bard")) then
        _return_value = false
        actor:send("Please specify:")
        if actor.level >= 50 and string.find(relocateclasses, "actor.class") then
            actor:send("Major Globe")
        end
        if actor.level >= 65 and string.find(actor.class, "Bard") then
            actor:send("Major Paralysis")
        end
    end
end
return _return_value