-- Trigger: Eye clarification
-- Zone: 4, ID: 80
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #480

-- Converted from DG Script #480: Eye clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "eye" then
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    if (actor.level >= 75 and string.find(actor.class, "Sorcerer")) or (actor.level >= 10 and string.find(hunterclasses, "actor.class")) then
        _return_value = false
        actor:send("Please specify:")
        if actor.level >= 75 and string.find(actor.class, "Sorcerer") then
            actor:send("Wizard Eye")
        end
        if actor.level >= 10 and string.find(hunterclasses, "actor.class") then
            actor:send("Eye of the tiger")
        end
    end
end
return _return_value