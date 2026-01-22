-- Trigger: academy_revel_command_eat
-- Zone: 519, ID: 64
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51964

-- Converted from DG Script #51964: academy_revel_command_eat
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: eat
if not (cmd == "eat") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "e" or cmd == "ea" then
    _return_value = false
    return _return_value
end
local meat = "large-chunk-meat"
if actor:get_quest_var("school:rest") == 6 and (string.find(meat, "arg") or string.find(food, "arg")) and actor:has_item("20305") then
    actor:set_quest_var("school", "rest", 7)
    actor:command("eat " .. tostring(arg))
    wait(2)
    self:command("eat meat")
    self:command("lick")
    actor:send(tostring(self.name) .. " tells you, 'Mmmmm, delicious!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'When you're all rested up you can head back out into the world.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'The best place to start your adventures is the <b:yellow>FARMLAND</> immediately west of the town of Mielikki, the starting town above us.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>HELP ZONE</> file will show you lots of places to explore.")
    actor:send("Type <b:green>help zone</> and check it out.'")
end
_return_value = false
return _return_value