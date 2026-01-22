-- Trigger: academy_cleric_command_rest
-- Zone: 519, ID: 41
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51941

-- Converted from DG Script #51941: academy_cleric_command_rest
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: rest
if not (cmd == "rest") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:fight") == 4 then
    actor:set_quest_var("school", "fight", 5)
    actor:command("rest")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Next, you should <b:cyan>(MED)ITATE</> to get into the proper state of mind.")
    actor:send("As it goes up, the <b:cyan>MEDITATE</> skill increases your <b:cyan>FOCUS</> score when you <b:cyan>MEDITATE</>.")
    actor:send("You can <b:cyan>MEDITATE</> as long as you're not in combat.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>meditate</> to start.'")
end
_return_value = false
return _return_value