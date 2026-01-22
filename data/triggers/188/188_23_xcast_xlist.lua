-- Trigger: xcast_xlist
-- Zone: 188, ID: 23
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18823

-- Converted from DG Script #18823: xcast_xlist
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: xlist
if not (cmd == "xlist") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- 
-- X-list
-- This trigger lists the spells available to x-decide and x-cast, triggers
-- 18820 and 18821.  It may only be used by mobiles in the 18820 to 18842
-- range, Laoris' dragonquest mobiles.
-- 
if (actor.id >= 18820) and (actor.id <= 18842) then
    _return_value = true
    actor:send("X-cast spells:           type       stars  amount")
    actor:send("</> deadly screech          area       0      300")
    actor:send("</> blizzard                area       2      300")
    actor:send("</> reconstitution          heal       2      1000")
    actor:send("</> hand of transport       transport  2")
    actor:send("</> defamation              area       2      400")
    actor:send("</> iron maiden             transport  1")
    actor:send("</> bodily charge           area       3      500")
    actor:send("</> archons curse           damage     2      500")
    actor:send("</> caustic conflaguration  damage     2      300")
else
    _return_value = false
end
return _return_value