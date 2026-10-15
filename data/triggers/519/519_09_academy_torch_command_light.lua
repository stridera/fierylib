-- Trigger: academy_torch_command_light
-- Zone: 519, ID: 9
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51909

-- Converted from DG Script #51909: academy_torch_command_light
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: light
if not (cmd == "light") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "l" then
        _return_value = true
        return _return_value
    end
end
-- `arg` is the typed argument ("torch"), not an object: this trigger sits on the academy torch
-- (0:23), so the lesson step applies when the argument names this object.
local names_this_torch = arg ~= "" and string.find(string.lower(tostring(self.name)), string.lower(arg), 1, true)
if (actor:get_quest_var("school:gear") or 0) == 5 and names_this_torch then
    -- The queued command below does the lighting, so the typed one is blocked (it would otherwise
    -- run first and the queued `light` would toggle the torch straight back off).
    _return_value = false
    actor:command("light " .. tostring(arg))
    actor:set_quest_var("school", "gear", 6)
    wait(0.2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Now you can see in dark spaces or outside at night!")
    actor:send("Remember, most lights have a limited duration.")
    actor:send("It's best to turn them off when not using them.")
    actor:send("</>")
    actor:send("Lights don't have to be equipped for you to see.")
    actor:send("They work just fine from your inventory.'")
    wait(3)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'You can stop using items by typing <b:cyan>REMOVE [object]</>.'")
    actor:send("</>")
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Stop wearing that torch by typing <b:green>remove torch</>.'")
    return _return_value
end
_return_value = true
return _return_value