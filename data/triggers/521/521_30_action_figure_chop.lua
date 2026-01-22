-- Trigger: action_figure_chop
-- Zone: 521, ID: 30
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52130

-- Converted from DG Script #52130: action_figure_chop
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: squeeze
if not (cmd == "squeeze") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if arg == "legs" then
    _return_value = true
    self.room:send(tostring(actor.name) .. " squeezes the legs of a Dakhod action figure.")
    self.room:send("The Dakhod action figure swings its arm in a wicked karate chop!")
else
    _return_value = false
end
return _return_value