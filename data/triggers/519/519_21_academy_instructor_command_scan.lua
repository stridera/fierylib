-- Trigger: academy_instructor_command_scan
-- Zone: 519, ID: 21
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51921

-- Converted from DG Script #51921: academy_instructor_command_scan
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: scan
if not (cmd == "scan") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "sc" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:explore") == 5 then
    actor:set_quest_var("school", "explore", 6)
    actor:command("scan")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You can move in any direction there's an open exit.")
    actor:send("Just type <b:cyan>(N)ORTH (S)OUTH (E)AST (W)EST (U)P</> or <b:cyan>(D)OWN</>.")
    actor:send("</>")
    actor:send("In the lower-left corner of your screen you'll see a display that looks like this:")
    actor:send("<b:yellow>10h(10H) 100v(100V)</>")
    actor:send("The two numbers on the right are your <b:magenta>Movement Points</>.")
    actor:send("The first number is your <b:magenta>Current Movement Points</>.")
    actor:send("The second number is your <b:magenta>Maximum Movement Points</>.")
    actor:send("Your <b:magenta>Maximum</> will increase until level 50.")
    actor:send("</>")
    actor:send("When you move from room to room, your Movement Points go down.")
    actor:send("The amount of Movement Points needed to move around varies by terrain.")
    actor:send("If your Movement Points reach 0 you can't move until you rest.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Would you like to review exploration?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end
_return_value = false
return _return_value