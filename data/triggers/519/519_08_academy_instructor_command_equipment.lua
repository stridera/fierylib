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
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "e" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:gear") or 0) == 3 then
    actor:set_quest_var("school", "gear", 4)
    actor:command("eq")
    wait(0.2)
    self:command("l " .. tostring(actor))
    actor:send(tostring(self.name) .. " tells you, 'You look well equipped to me!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Another way to equip things is with the <b:cyan>(HO)LD</> command.")
    if actor:has_item(0, 23) or actor:has_equipped(0, 23) then
        actor:send("You started play with a torch.'")
    else
        actor:send("Here, take this torch for example.'")
        self.room:spawn_object(0, 23)
        self:command("give torch " .. tostring(actor))
    end
    wait(3)
    if actor:has_equipped(0, 23) then
        -- WEAR ALL already put the torch in the off-hand, so HOLD TORCH would only say
        -- "You are already holding..." and the lesson would stall: take the next step now.
        actor:set_quest_var("school", "gear", 5)
        actor:send(tostring(self.name) .. " tells you, 'Looks like you are already holding it, so you can skip that step.")
        actor:send("However, you need to turn it on before it provides you any light.")
        actor:send("The <b:cyan>(LI)GHT</> command turns lights on and off.")
        actor:send("You can just type <b:cyan>light torch</> to light it up.")
        actor:send("If it's already lit, you can type <b:cyan>light torch</> again to extinguish it.'")
        wait(3)
        actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Give it a try and type <b:green>light torch</>.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Type <b:green>hold torch</> to equip it.'")
    end
end
_return_value = true
return _return_value