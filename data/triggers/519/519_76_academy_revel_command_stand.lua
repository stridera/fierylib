-- Trigger: academy_revel_command_stand
-- Zone: 519, ID: 76
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51976

-- Converted from DG Script #51976: academy_revel_command_stand
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stand
if not (cmd == "stand") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:rest") == 4 then
    actor:set_quest_var("school", "rest", 5)
    actor:command("stand")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Now you can <b:green>fill waterskin fountain</>.'")
end
_return_value = false
return _return_value