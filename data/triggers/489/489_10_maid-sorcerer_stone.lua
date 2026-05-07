-- Trigger: maid-sorcerer stone
-- Zone: 489, ID: 10
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48910

-- Converted from DG Script #48910: maid-sorcerer stone
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stone -- Lokari (id 48901) issues "stone" to ask the
-- sorcerer maid to stoneskin him on her next fight tick.
if not (cmd == "stone") then
    return true  -- Not our command
end
if actor.id == 48901 then
    globals.stone = 1
end
return true