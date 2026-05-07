-- Trigger: Rydack_test
-- Zone: 590, ID: 3
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
-- Note: developer test/debug trigger (probably never wired up). Kept verbatim
-- for archive purposes; not intended for production use.
--
-- Original DG Script: #59003

-- Converted from DG Script #59003: Rydack_test
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- TODO(parity): original was a developer probe; logic and message text are
-- inconsistent (claims "not wearing shield" inside the wearing branch). Leave
-- as-is until intent is confirmed by the area author.

-- Command filter: fire
if not (cmd == "fire") then
    return true  -- Not our command
end
local _return_value = false
if actor:get_worn("shield") then
    self.room:send("ok, not wearing shield")
    local shield_obj = actor:get_worn("shield")
    self.room:send(tostring(shield_obj))
end
return _return_value