-- Trigger: Wand clarification
-- Zone: 4, ID: 73
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #473

-- Converted from DG Script #473: Wand clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "wand" then
    local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        actor:send("Please specify:")
        actor:send("Acid Wand")
        actor:send("Air Wand")
        actor:send("Fire Wand")
        actor:send("Ice Wand")
    end
end
return _return_value