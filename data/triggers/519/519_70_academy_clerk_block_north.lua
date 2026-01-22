-- Trigger: academy_clerk_block_north
-- Zone: 519, ID: 70
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51970

-- Converted from DG Script #51970: academy_clerk_block_north
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: north
if not (cmd == "north") then
    return true  -- Not our command
end
-- switch on actor.class
if actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" or actor.class == "bard" then
    actor:send(tostring(self.name) .. " tells you, 'Your trainer is down.'")
elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" then
    actor:send(tostring(self.name) .. " tells you, 'Your trainer is to the east.'")
elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "illusionist" or actor.class == "necromancer" then
    actor:send(tostring(self.name) .. " tells you, 'Your trainer is to the south.'")
elseif actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "berserker" or actor.class == "monk" then
    actor:move("north")
else
    actor:send(tostring(self.name) .. " tells you, 'Hmmm, I don't actually know where to send you...  Talk to a god.'")
end