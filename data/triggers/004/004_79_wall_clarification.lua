-- Trigger: Wall clarification
-- Zone: 4, ID: 79
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #479

-- Converted from DG Script #479: Wall clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "wall" then
    if actor.level >= 50 and (string.find(actor.class, "cryomancer") or string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) then
        _return_value = true
        actor:send("Please specify:")
        if string.find(actor.class, "cryomancer") then
            actor:send("Wall of Ice")
        end
        if string.find(actor.class, "illusionist") or string.find(actor.class, "bard") then
            actor:send("Illusory Wall")
        end
    end
end
return _return_value