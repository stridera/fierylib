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
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:fight") == 3 and string.find(arg, "autosplit") then
    actor:set_quest_var("school", "fight", 4)
    actor:command("toggle autosplit")
    wait(2)
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
    if actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" or actor.class == "bard" then
        actor:send(self.name .. " tells you, '" .. "I see you're a stealthy type." .. "'")
        actor:send(self.name .. " tells you, '" .. "You'll do best in lessons with Doctor Mischief." .. "'")
        actor:send(self.name .. " tells you, '" .. "Proceed down to her classroom." .. "'")
    elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "necromancer" or actor.class == "illusionist" then
        actor:send(self.name .. " tells you, '" .. "I see you're an arcane spell caster." .. "'")
        actor:send(self.name .. " tells you, '" .. "You would definitely benefit from" .. "'")
        actor:send(self.name .. " tells you, '" .. "The Chair of Arcane Studies' seminar on spellcasting." .. "'")
        actor:send(self.name .. " tells you, '" .. "Proceed south to his laboratory." .. "'")
    elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" then
        actor:send(self.name .. " tells you, '" .. "I see you're a divine spell caster." .. "'")
        actor:send(self.name .. " tells you, '" .. "You would definitely benefit from" .. "'")
        actor:send(self.name .. " tells you, '" .. "Private classes with the Professor of Divinity." .. "'")
        actor:send(self.name .. " tells you, '" .. "Proceed east to his chapel." .. "'")
    elseif actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "monk" or actor.class == "berserker" then
    else
        actor:send(self.name .. " tells you, '" .. "I see you're a fighter type." .. "'")
        actor:send(self.name .. " tells you, '" .. "You'll do best learning from the Academy's Warmaster." .. "'")
        actor:send(self.name .. " tells you, '" .. "Proceed north to her arena." .. "'")
    end
else
    _return_value = false
end
return _return_value