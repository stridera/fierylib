-- Trigger: academy_clerk_block_east
-- Zone: 519, ID: 68
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51968

-- Converted from DG Script #51968: academy_clerk_block_east
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
-- switch on actor.class
if actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "berserker" or actor.class == "monk" then
    actor:send(tostring(self.name) .. " tells you, 'Your trainer is to the north.'")
elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "illusionist" or actor.class == "necromancer" then
    actor:send(tostring(self.name) .. " tells you, 'Your trainer is to the south.'")
elseif actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" or actor.class == "bard" then
    actor:send(tostring(self.name) .. " tells you, 'Your trainer is down.'")
elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" then
    actor:move("east")
else
    actor:send(tostring(self.name) .. " tells you, 'Hmmm, I don't actually know where to send you...  Talk to a god.'")
end