-- Trigger: academy_instructor_command_junk
-- Zone: 519, ID: 13
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51913

-- Converted from DG Script #51913: academy_instructor_command_junk
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: junk
if not (cmd == "junk") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:gear") == 11 and arg.id == 51902 then
    actor:set_quest_var("school", "gear", 12)
    actor:command("junk " .. tostring(arg))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Very good.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You can drop and junk everything with the same keyword by typing in <b:cyan>all.[object]</> as well.")
    actor:send("But <b:red>be careful</>!  You might end up junking something with a surprising keyword by accident!'</>")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Another way to deal with items is to <b:cyan>(GI)VE</> them away.")
    actor:send("You can do that by typing <b:cyan>GIVE [object] [person]</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Give me a stick by typing <b:green>give stick instructor</>.'")
end
_return_value = false
return _return_value