-- Trigger: dormitory_sleep
-- Zone: 17, ID: 3
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1703

-- Converted from DG Script #1703: dormitory_sleep
-- Original: WORLD trigger, flags: COMMAND, probability: 100%
-- Intent: when a player types "sleep" in this dormitory room while
-- already resting/alert, instead trigger the rent flow.

-- Command filter: sleep
if cmd ~= "sleep" then
    return true  -- Not our command; allow default handling
end

-- Only intercept for player actors
if not actor or actor.is_npc then
    return true
end

-- TODO: Re-enable once `actor.stance` and `actor:rent()` bindings exist.
-- Original DG Script gated rent on stance == resting/alert and called
-- the rent command. For now allow the default "sleep" action through.
return true