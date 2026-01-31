-- Trigger: academy_revel_command_wake
-- Zone: 519, ID: 61
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51961

-- Converted from DG Script #51961: academy_revel_command_wake
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: wake
if not (cmd == "wake") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "w" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:rest") == 2 then
    actor:set_quest_var("school", "rest", 3)
    actor:command("wake")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Good morning sunshine!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You'll frequently notice yourself getting hungry or thirsty.")
    actor:send("You can speed up your recovery if you <b:cyan>EAT</> and <b:cyan>(DRI)NK</>.")
    actor:send("</>")
    actor:send("When you get thirsty it's time to <b:cyan>DRINK</>!")
    actor:send("Ethilien has a huge variety of drinkable liquids.")
    actor:send("Any of them will slake your thirst.")
    actor:send("The command is <b:cyan>DRINK [container]</>.")
    actor:send("</>")
    actor:send("When you <b:cyan>DRINK</>, you'll also regain some Movement Points, so make sure you carry a full waterskin so you can keep moving when you explore!")
    actor:send("</>")
    actor:send("And remember, magic potions are <red>not</> drinks.")
    actor:send("If you want to consume a potion, the commmand is <b:cyan>(Q)UAFF</>, not <b:cyan>(DRI)NK</>.'")
    wait(2)
    if not actor:has_item("20") and not actor:has_equipped("20") then
        actor:send(tostring(self.name) .. " tells you, 'Here's a new waterskin for you.")
        self.room:spawn_object(0, 20)
        self:command("give waterskin " .. tostring(actor))
    else
        actor:send(tostring(self.name) .. " tells you, 'You started play with a full waterskin.")
    end
    actor:send("Type <b:green>drink waterskin</> now to drink out of it.'")
end
_return_value = false
return _return_value