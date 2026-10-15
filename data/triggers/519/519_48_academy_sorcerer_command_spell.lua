-- Trigger: academy_sorcerer_command_spell
-- Zone: 519, ID: 48
-- Type: MOB, Flags: COMMAND
--
-- Original DG Script: #51948

-- Converted from DG Script #51948: academy_sorcerer_command_spell
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: spells
if not (cmd == "spells") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "sp" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 2 then
    actor:set_quest_var("school", "fight", 3)
    actor:command("spells")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Spells are divided up by Circle.")
    actor:send("For now you only have access to Circle 1 spells.")
    actor:send("You gain access to a new Circle every 8 levels.")
    actor:send("You can find out what any spell does by consulting the <b:cyan>HELP</> file.")
    actor:send("</>")
    actor:send("For now, you're going to learn <b:yellow>magic missile</>.")
    actor:send("</>")
    actor:send("<b:cyan>(REM)OVE</> anything in your hands.")
    actor:send("Then <b:cyan>(H)OLD</> your spellbook.'")
    wait(2)
    if actor:get_worn("wield") then
        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the weapon in your hands.'")
    end
    if actor:get_worn("hold") then
        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the item in your hands.'")
    end
    if actor:get_worn("hold2") then
        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the item in your hands.'")
    end
    if actor:get_worn("2hwield") then
        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the item in your hands.'")
    end
    actor:send("</>")
    if not actor:has_equipped(10, 29) and not actor:has_item(10, 29) then
        actor:send(tostring(self.name) .. " tells you, 'Looks like you need a new book too.'")
        self.room:spawn_object(10, 29)
        self:command("give book " .. tostring(actor))
        actor:send("</>")
    end
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>hold spellbook</> to grab your book.'")
end
_return_value = true
return _return_value