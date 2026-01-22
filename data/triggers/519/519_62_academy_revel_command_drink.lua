-- Trigger: academy_revel_command_drink
-- Zone: 519, ID: 62
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51962

-- Converted from DG Script #51962: academy_revel_command_drink
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "d" or cmd == "dr" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:rest") == 3 and (string.find(waterskin, "arg") or string.find(leather, "arg") or string.find(skin, "arg")) then
    actor:set_quest_var("school", "rest", 4)
    actor:command("drink " .. tostring(arg))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Cheers!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Every now and then you'll have to <b:cyan>FILL</> your drinking vessel.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Throughout the world you'll find many springs and fountains.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Like this one!'")
    self:command("point fountain")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>FILL</> a drink container from a source like this by typing <b:cyan>FILL [container] [source]</>.'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'But first you have to <b:green>stand</> up.'")
end
_return_value = false
return _return_value