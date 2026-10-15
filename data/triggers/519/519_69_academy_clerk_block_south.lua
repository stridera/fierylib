-- Trigger: academy_clerk_block_south
-- Zone: 519, ID: 69
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51969

-- Converted from DG Script #51969: academy_clerk_block_south
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
-- switch on actor.class
do
    local _sw1 = string.lower(tostring(actor.class or ""))
    if _sw1 == "warrior" or _sw1 == "paladin" or _sw1 == "anti-paladin" or _sw1 == "ranger" or _sw1 == "berserker" or _sw1 == "monk" then
        actor:send(tostring(self.name) .. " tells you, 'Your trainer is to the north.'")
    elseif _sw1 == "rogue" or _sw1 == "thief" or _sw1 == "assassin" or _sw1 == "mercenary" or _sw1 == "bard" then
        actor:send(tostring(self.name) .. " tells you, 'Your trainer is down.'")
    elseif _sw1 == "cleric" or _sw1 == "priest" or _sw1 == "diabolist" or _sw1 == "druid" then
        actor:send(tostring(self.name) .. " tells you, 'Your trainer is to the east.'")
    elseif _sw1 == "sorcerer" or _sw1 == "cryomancer" or _sw1 == "pyromancer" or _sw1 == "illusionist" or _sw1 == "necromancer" then
        actor:move("south")
    else
        actor:send(tostring(self.name) .. " tells you, 'Hmmm, I don't actually know where to send you...  Talk to a god.'")
    end
end