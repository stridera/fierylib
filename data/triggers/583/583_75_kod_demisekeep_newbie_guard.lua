-- Trigger: KoD_demisekeep_newbie_guard
-- Zone: 583, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #58375

-- Converted from DG Script #58375: KoD_demisekeep_newbie_guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 30 then
        self:command("smile")
        self:whisper(actor.name, "I would not suggest going any further.")
        wait(1)
        self:command("grin " .. tostring(actor.name))
        self:whisper(actor.name, "It is fraught with danger above your abilities.")
    elseif actor.level < 60 then
        self:say("I will let you pass, but still be careful beyond this point.")
        self:emote("points east.")
        wait(5)
        actor:move("east")
    else
        _return_value = false
    end
end
return _return_value