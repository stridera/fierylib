-- Trigger: pyramid_entrance_newbie_guard
-- Zone: 162, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #16275

-- Converted from DG Script #16275: pyramid_entrance_newbie_guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%
--
-- Block players under level 40 from going north into the pyramid; mobs and
-- higher-level players walk through normally.

if cmd ~= "north" then
    return true  -- Not our command
end
if actor.is_player and actor.level < 40 then
    self:command("laugh " .. tostring(actor.name))
    self:whisper(actor.name, "You should go try somewhere a little more manageable for you.")
    wait(1)
    self:whisper(actor.name, "You will grow to adventure here soon enough.")
    self:command("bow")
    return false  -- Block the north movement
end
return true  -- Allow movement