-- Trigger: academy_instructor_command_open
-- Zone: 519, ID: 20
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51920

-- Converted from DG Script #51920: academy_instructor_command_open
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: open
if not (cmd == "open") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "o" then
    _return_value = false
    return _return_value
end
-- switch on arg
if actor:get_quest_var("school:explore") == 4 then
    if arg == "c" or arg == "cu" or arg == "cur" or arg == "curt" or arg == "curta" or arg == "curtai" or arg == "curtain" then
        actor:set_quest_var("school", "explore", 5)
        actor:command("open curtain")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Perfect!'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Now that the door is open, you can <b:cyan>(SCA)N</> to see what's in the areas around you.")
        actor:send("It's free to use and very helpful for anticipating threats.")
        actor:send("Some classes are even able to see more than one room away.")
        actor:send("There is a slight delay after giving the <b:cyan>SCAN</> command, so be careful.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Give it a go!  Type <b:green>scan</>.'")
    end
end
_return_value = false
return _return_value