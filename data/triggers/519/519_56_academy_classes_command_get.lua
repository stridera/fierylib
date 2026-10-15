-- Trigger: academy_classes_command_get
-- Zone: 519, ID: 56
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51956

-- Converted from DG Script #51956: academy_classes_command_get
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: get
if not (cmd == "get") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on arg
do
    local _sw1 = string.lower(tostring(arg or ""))
    if _sw1 == "all c" or _sw1 == "all co" or _sw1 == "all cor" or _sw1 == "all corp" or _sw1 == "all corps" or _sw1 == "all corpse" then
        if (actor:get_quest_var("school:loot") or 0) == 1 then
            actor:set_quest_var("school", "loot", 2)
            actor:command("get all corpse")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'And now you have some money!")
            actor:send("Remember, use <b:cyan>SCORE</> to check your money.")
            actor:send("</>")
            actor:send("The other thing I need to show you is the <b:cyan>TOGGLE</> command.")
            actor:send("Typing <b:cyan>TOGGLE</> alone will show you everything you can set.")
            actor:send("<b:cyan>AUTOLOOT</> picks up everything from a corpse instantly.")
            actor:send("<b:cyan>AUTOTREAS</> picks up only \"treasure\" like coins and gems.")
            actor:send("Each toggle has a <b:cyan>HELP</> file with more information.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'For now, let's get you ready to gather and share loot.")
            actor:send("Type <b:green>toggle autoloot</> to loot future kills!'")
        end
    end
end
_return_value = true
return _return_value