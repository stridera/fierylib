-- Trigger: action_figure_chop
-- Zone: 521, ID: 30
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52130

-- Converted from DG Script #52130: action_figure_chop
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: squeeze
if not (cmd == "squeeze") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if arg == "legs" then
    _return_value = false
    self.room:send(actor.name .. " squeezes the legs of a Dakhod action figure.")
    self.room:send("The Dakhod action figure swings its arm in a wicked karate chop!")
end
return _return_value