-- Trigger: academy_instructor_command_equipment
-- Zone: 519, ID: 8
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51908

-- Converted from DG Script #51908: academy_instructor_command_equipment
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: equipment
if not (cmd == "equipment") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "e" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:gear") == 3 then
    actor:set_quest_var("school", "gear", 4)
    actor:command("eq")
    wait(2)
    self:command("l " .. tostring(actor))
    actor:send(tostring(self.name) .. " tells you, 'You look well equipped to me!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Another way to equip things is with the <b:cyan>(HO)LD</> command.")
    if actor:has_item("23") or actor:has_equipped("23") then
        actor:send("You started play with a torch.'")
    else
        actor:send("Here, take this torch for example.'")
        self.room:spawn_object(1000, 23)
        self:command("give torch " .. tostring(actor))
    end
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>hold torch</> to equip it.'")
end
_return_value = false
return _return_value