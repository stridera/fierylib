-- Trigger: supernova_gateway_enter_command
-- Zone: 62, ID: 13
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6213

-- Converted from DG Script #6213: supernova_gateway_enter_command
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: enter
if not (cmd == "enter") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "e" then
    _return_value = false
    return _return_value
end
-- switch on arg
if actor:has_item("51073") or actor:has_equipped("51073") then
    if arg == "r" or arg == "ri" or arg == "rin" or arg == "ring" or arg == "g" or arg == "ga" or arg == "gat" or arg == "gate" or arg == "gatew" or arg == "gatewa" or arg == "gateway" then
        actor:send("The gateway draws power from " .. tostring(objects.template(510, 73).name) .. " and activates!")
        _return_value = false
        wait(2)
        self.room:send("The gateway folds in on itself and collapses!")
        world.destroy(self)
    else
        _return_value = true
        actor:send("The gateway is inactive.")
    end
else
    _return_value = false
end
return _return_value