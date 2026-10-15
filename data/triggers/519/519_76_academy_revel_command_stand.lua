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
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_var("school:rest") == 4 then
    actor:set_quest_var("school", "rest", 5)
    actor:command("stand")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Now you can <b:green>fill waterskin fountain</>.'")
end
_return_value = true
return _return_value