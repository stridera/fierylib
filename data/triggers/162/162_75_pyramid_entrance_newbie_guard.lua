-- Trigger: pyramid_entrance_newbie_guard
-- Zone: 162, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #16275

-- Converted from DG Script #16275: pyramid_entrance_newbie_guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: north
if not (cmd == "north") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 40 then
        self:command("laugh " .. tostring(actor.name))
        self:whisper(actor.name, "You should go try somewhere a little more manageable for you.")
        wait(1)
        self:whisper(actor.name, "You will grow to adventure here soon enough.")
        self:command("bow")
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value