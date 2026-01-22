-- Trigger: Guild/Phase clarification
-- Zone: 4, ID: 77
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #477

-- Converted from DG Script #477: Guild/Phase clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "guild" or arg == "phase" or arg == "guild phase armor" or arg == "guild armor" or arg == "phase armor" or arg == "phase_armor" then
    _return_value = false
    actor:send("Please specify:")
    actor:send("Guild Armor Phase One")
    actor:send("Guild Armor Phase Two")
    actor:send("Guild Armor Phase Three")
end
return _return_value