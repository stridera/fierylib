-- Trigger: academy_clerk_command_toggle
-- Zone: 519, ID: 25
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51925

-- Converted from DG Script #51925: academy_clerk_command_toggle
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: toggle
if not (cmd == "toggle") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor:get_quest_var("school:fight") == 3 and string.find(arg, "autosplit") then
    actor:set_quest_var("school", "fight", 4)
    actor:command("toggle autosplit")
    wait(0.2)
    actor:send(self.name .. " tells you, '" .. "Grand." .. "'")
    actor:send(self.name .. " tells you, '" .. "You're ready to continue." .. "'")
    wait(1)
    self:command("eye " .. tostring(actor))
    wait(1)
    actor:send(tostring(self.name) .. " considers your capabilities...")
    wait(3)
    actor:send(self.name .. " tells you, '" .. "Hmmmm..." .. "'")
    wait(2)
    -- switch on actor.class
    do
        local _sw1 = string.lower(tostring(actor.class or ""))
        if _sw1 == "rogue" or _sw1 == "thief" or _sw1 == "assassin" or _sw1 == "mercenary" or _sw1 == "bard" then
            actor:send(self.name .. " tells you, '" .. "I see you're a stealthy type." .. "'")
            actor:send(self.name .. " tells you, '" .. "You'll do best in lessons with Doctor Mischief." .. "'")
            actor:send(self.name .. " tells you, '" .. "Proceed down to her classroom." .. "'")
        elseif _sw1 == "sorcerer" or _sw1 == "cryomancer" or _sw1 == "pyromancer" or _sw1 == "necromancer" or _sw1 == "illusionist" then
            actor:send(self.name .. " tells you, '" .. "I see you're an arcane spell caster." .. "'")
            actor:send(self.name .. " tells you, '" .. "You would definitely benefit from" .. "'")
            actor:send(self.name .. " tells you, '" .. "The Chair of Arcane Studies' seminar on spellcasting." .. "'")
            actor:send(self.name .. " tells you, '" .. "Proceed south to his laboratory." .. "'")
        elseif _sw1 == "cleric" or _sw1 == "priest" or _sw1 == "diabolist" or _sw1 == "druid" then
            actor:send(self.name .. " tells you, '" .. "I see you're a divine spell caster." .. "'")
            actor:send(self.name .. " tells you, '" .. "You would definitely benefit from" .. "'")
            actor:send(self.name .. " tells you, '" .. "Private classes with the Professor of Divinity." .. "'")
            actor:send(self.name .. " tells you, '" .. "Proceed east to his chapel." .. "'")
            actor:send(self.name .. " tells you, '" .. "I see you're a fighter type." .. "'")
            actor:send(self.name .. " tells you, '" .. "You'll do best learning from the Academy's Warmaster." .. "'")
            actor:send(self.name .. " tells you, '" .. "Proceed north to her arena." .. "'")
        end
    end
else
    _return_value = true
end
return _return_value