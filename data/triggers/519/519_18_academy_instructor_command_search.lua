-- Trigger: academy_instructor_command_search
-- Zone: 519, ID: 18
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51918

-- Converted from DG Script #51918: academy_instructor_command_search
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
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
-- switch on arg
do
    local _sw2 = string.lower(tostring(arg or ""))
    if _sw2 == "c" or _sw2 == "cu" or _sw2 == "cur" or _sw2 == "curt" or _sw2 == "curta" or _sw2 == "curtai" or _sw2 == "curtain" then
        if (actor:get_quest_var("school:explore") or 0) == 3 then
            actor:set_quest_var("school", "explore", 4)
            actor:command("search curtain")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Exactly, just like that!")
            actor:send("<b:cyan>SEARCH</> can also find hidden objects or creatures.")
            actor:send("</>")
            actor:send("Once you've uncovered the door you can interact with it like a normal door.")
            actor:send("You can use the <b:cyan>(O)PEN</> and <b:cyan>(CL)OSE</> commands to open doors or containers.")
            actor:send("Sometimes they might be locked though, and you'll need a key to unlock them.")
            actor:send("</>")
            actor:send("If you <b:cyan>LOOK EAST</>, you can see the curtain is closed.")
            actor:send("To open it just use the <b:cyan>(O)PEN</> command.'</>")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>open curtain</> to see how it works.'")
        end
        _return_value = true
    else
        if (actor:get_quest_var("school:explore") or 0) == 3 then
            actor:send(tostring(self.name) .. " tells you, 'No no, you have to <b:green>search curtain</>.'")
        else
            _return_value = true
        end
    end
end
return _return_value