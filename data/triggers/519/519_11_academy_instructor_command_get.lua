-- Trigger: academy_instructor_command_get
-- Zone: 519, ID: 11
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51911

-- Converted from DG Script #51911: academy_instructor_command_get
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: get
if not (cmd == "get") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:gear") == 7 then
    if arg.id == 51902 then
        actor:set_quest_var("school", "gear", 8)
        actor:command("get " .. tostring(arg))
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Well done!  It's as simple as that!'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'If you don't want to pick up the first one, you can target a different one by adding a number and a \".\" before the name.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Try typing <b:green>get 2.stick</> and see what happens.'")
    end
elseif actor:get_quest_var("school:gear") == 8 then
    if arg.id == 51902 and string.find(arg, "2.") then
        actor:set_quest_var("school", "gear", 9)
        actor:command("get " .. tostring(arg))
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Yes, like that.'")
        actor:send("</>")
        actor:send("You can also pick up all of one thing by typing <b:cyan>GET all.[object]</>.")
        actor:send("Or you can be extra greedy by typing <b:cyan>GET ALL</>.")
        actor:send("That will pick up everything in the room.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Type <b:green>get all</> with nothing after it.'")
    end
elseif actor:get_quest_var("school:gear") == 9 and arg == "all" then
    actor:set_quest_var("school", "gear", 10)
    actor:command("get all")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Those are some sticky fingers!'")
    self:command("laugh")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Now it's possible your inventory might get full.")
    actor:send("You can only carry so many items in your inventory at once but there are a few ways to deal with that.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'First, you can <b:cyan>(DRO)P</> items with the command <b:cyan>DROP [object]</>.'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Drop one of those sticks by typing <b:green>drop stick</>.'")
elseif actor:get_quest_var("school:gear") == 15 and string.find(arg, "stick") bag then
    actor:set_quest_var("school", "gear", 16)
    actor:command("get stick bag")
    wait(2)
    self:command("cheer")
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Congratulations, you mastered equipment management!")
    actor:send("Would you like to review?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end
_return_value = false
return _return_value