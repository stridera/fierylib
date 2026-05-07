-- Trigger: xcast_xdecide
-- Zone: 188, ID: 21
-- Type: OBJECT, Flags: GLOBAL, COMMAND
-- Status: NEEDS_REVIEW (parses, behavior partly broken; see TODOs)
--
-- Original DG Script: #18821
-- Converted from DG Script #18821: xcast_xdecide
-- Original: OBJECT trigger, flags: GLOBAL, COMMAND, probability: 3%
--
-- TODO(parity): Conversion of the DG `if %arg.contains(...)` cascade is mangled;
-- some branches test bare identifiers (e.g. `string.find(deadly, "arg")`) that
-- are nil at runtime, so spell-name shortcuts will not match. Replace each
-- branch with `string.find("arctic blast", arg, 1, true)` style tests against
-- the canonical spell name and the user-supplied `arg` substring.

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: xdecide
if not (cmd == "xdecide") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- 
-- X-decide
-- This trigger works with 18820, x-cast, to cast custom spells with various
-- effects.  It may only be used by mobiles in the 18820 to 18842 range,
-- Laoris' dragonquest mobiles.
-- 
-- Expected variables set by x-decide:
-- xid - unique integer identifier, like 1
-- xname - name of the spell, such as 'arctic blast'
-- xstars - duration to cast the spell, ie., 2
-- xmagic - magic words uttered at the end of the spell, like 'zimblo argis'
-- xeffect - actual effect of the spell, such as 'damage' or 'expel'
-- xmode - sets whether it's victim or self-only
-- xamount - only meaningful for some spell types, ie., 100
-- 
if (actor.id >= 18820) and (actor.id <= 18842) then
    -- Block 'Huh?!?' message
    _return_value = false
    -- Choose spell
    -- These if statements allow the user to only type part of the spell
    -- name, such as just 'arc' for 'arctic blast'.  However, this also
    -- allows 'blast', so making another spell 'blast of fire' is a bad
    -- idea.  Use unique spell names.
    local xid, xname, xstars, xmagic, xeffect, xmode, xamount
    local needle = arg or ""
    if string.find("deadly screech", needle, 1, true) then
        xid = 1; xname = "deadly screech"; xstars = 0
        xmagic = "shelak frhoonl"; xeffect = "area"; xmode = "self"; xamount = 300
    elseif string.find("blizzard", needle, 1, true) then
        xid = 2; xname = "blizzard"; xstars = 2
        xmagic = "shelaki"; xeffect = "area"; xmode = "self"; xamount = 300
    elseif string.find("reconstitution", needle, 1, true) then
        xid = 3; xname = "reconstitution"; xstars = 2
        xmagic = "mellagenipoir"; xeffect = "heal"; xmode = "self"; xamount = 1000
    elseif string.find("hand of transport", needle, 1, true) then
        xid = 4; xname = "hand of transport"; xstars = 2
        xmagic = "franti ay sakchorish"; xeffect = "transport"; xmode = "victim"; xamount = -1
    elseif string.find("defamation", needle, 1, true) then
        xid = 5; xname = "defamation"; xstars = 2
        xmagic = "rotulugeaf"; xeffect = "area"; xmode = "self"; xamount = 400
    elseif string.find("iron maiden", needle, 1, true) then
        xid = 6; xname = "iron maiden"; xstars = 1
        xmagic = "grak oblithron"; xeffect = "transport"; xmode = "victim"; xamount = 18820
    elseif string.find("bodily charge", needle, 1, true) then
        xid = 7; xname = "bodily charge"; xstars = 3
        xmagic = "corpeno elekar"; xeffect = "area"; xmode = "self"; xamount = 500
    elseif string.find("archons curse", needle, 1, true) then
        xid = 8; xname = "archons curse"; xstars = 2
        xmagic = "colrio goladhr"; xeffect = "damage"; xmode = "victim"; xamount = 500
    elseif string.find("caustic conflaguration", needle, 1, true) then
        xid = 9; xname = "caustic conflaguration"; xstars = 2
        xmagic = "akridsi donoeplarinius"; xeffect = "damage"; xmode = "victim"; xamount = 300
    else
        actor:send("That is not a valid x-cast spell.")
    end
    if xname then
        actor:send("x-cast spell set to: " .. tostring(xname))
        globals.xname = xname
        globals.xid = xid
        globals.xstars = xstars
        globals.xmagic = xmagic
        globals.xeffect = xeffect
        globals.xmode = xmode
        globals.xamount = xamount
    end
else
    -- Do nothing for non-dragonquest mobs
    _return_value = true
end
return _return_value