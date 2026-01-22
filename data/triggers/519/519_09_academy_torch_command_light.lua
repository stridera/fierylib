-- Trigger: academy_torch_command_light
-- Zone: 519, ID: 9
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51909

-- Converted from DG Script #51909: academy_torch_command_light
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: light
if not (cmd == "light") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "l" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:gear") == 5 and arg.id == 23 then
    actor:command("light %arg%")
    actor:set_quest_var("school", "gear", 6)
    wait(2)
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
end
_return_value = false
return _return_value