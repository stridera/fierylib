-- Trigger: academy_classes_command_toggle_split
-- Zone: 519, ID: 74
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51974

-- Converted from DG Script #51974: academy_classes_command_toggle_split
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: toggle
if not (cmd == "toggle") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "t" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:loot") or 0) == 2 then
    -- switch on arg
    do
        local _sw2 = string.lower(tostring(arg or ""))
        if _sw2 == "autol" or _sw2 == "autolo" or _sw2 == "autoloo" or _sw2 == "autoloot" then
            actor:set_quest_var("school", "loot", 3)
            actor:command("toggle autoloot")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Grand.'")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'When playing with others it's considered polite to share the wealth.")
            actor:send("You can share money with the <b:cyan>SPLIT</> command.")
            actor:send("With <b:cyan>TOGGLE AUTOSPLIT</> on the game will automatically do that when you pick up money.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>toggle autosplit</> to set that.'")
        end
    end
elseif (actor:get_quest_var("school:loot") or 0) == 3 then
    -- switch on arg
    do
        local _sw3 = string.lower(tostring(arg or ""))
        if _sw3 == "autos" or _sw3 == "autosp" or _sw3 == "autospl" or _sw3 == "autospli" or _sw3 == "autosplit" then
            actor:set_quest_var("school", "loot", 4)
            actor:command("toggle autosplit")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Now you'll play nice with other people!'")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'The last combat tip is checking your <b:cyan>(TRO)PHY</> list.")
            actor:send("<b:cyan>TROPHY</> shows a record of the last 24 creatures you've killed and how many times you've killed them.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>trophy</> and see your record.'")
        end
    end
end
_return_value = true
return _return_value