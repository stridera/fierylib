-- Trigger: xcast_xdecide
-- Zone: 188, ID: 21
-- Type: OBJECT, Flags: GLOBAL, COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #18821

-- Converted from DG Script #18821: xcast_xdecide
-- Original: OBJECT trigger, flags: GLOBAL, COMMAND, probability: 3%

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
    _return_value = true
    -- Choose spell
    -- These if statements allow the user to only type part of the spell
    -- name, such as just 'arc' for 'arctic blast'.  However, this also
    -- allows 'blast', so making another spell 'blast of fire' is a bad
    -- idea.  Use unique spell names.
    if deadly string.find(screech, "arg") then
        local xid = 1
        local xname = "deadly screech"
        local xstars = 0
        local xmagic = "shelak frhoonl"
        local xeffect = "area"
        local xmode = "self"
        local xamount = 300
    elseif string.find(blizzard, "arg") then
        local xid = 2
        local xname = "blizzard"
        local xstars = 2
        local xmagic = "shelaki"
        local xeffect = "area"
        local xmode = "self"
        local xamount = 300
    elseif string.find(reconstitution, "arg") then
        local xid = 3
        local xname = "reconstitution"
        local xstars = 2
        local xmagic = "mellagenipoir"
        local xeffect = "heal"
        local xmode = "self"
        local xamount = 1000
    elseif hand of string.find(transport, "arg") then
        local xid = 4
        local xname = "hand of transport"
        local xstars = 2
        local xmagic = "franti ay sakchorish"
        local xeffect = "transport"
        local xmode = "victim"
        local xamount = -1
    elseif string.find(defamation, "arg") then
        local xid = 5
        local xname = "defamation"
        local xstars = 2
        local xmagic = "rotulugeaf"
        local xeffect = "area"
        local xmode = "self"
        local xamount = 400
    elseif iron string.find(maiden, "arg") then
        local xid = 6
        local xname = "iron maiden"
        local xstars = 1
        local xmagic = "grak oblithron"
        local xeffect = "transport"
        local xmode = "victim"
        local xamount = 18820
    elseif bodily string.find(charge, "arg") then
        local xid = 7
        local xname = "bodily charge"
        local xstars = 3
        local xmagic = "corpeno elekar"
        local xeffect = "area"
        local xmode = "self"
        local xamount = 500
    elseif archons string.find(curse, "arg") then
        local xid = 8
        local xname = "archons curse"
        local xstars = 2
        local xmagic = "colrio goladhr"
        local xeffect = "damage"
        local xmode = "victim"
        local xamount = 500
    elseif caustic string.find(conflaguration, "arg") then
        local xid = 9
        local xname = "caustic conflaguration"
        local xstars = 2
        local xmagic = "akridsi donoeplarinius"
        local xeffect = "damage"
        local xmode = "victim"
        local xamount = 300
    else
        actor:send("That is not a valid x-cast spell.")
    end
    if xname then
        actor:send("x-cast spell set to: " .. tostring(xname))
        globals.xname = globals.xname or true
    end
    if xid then
        globals.xid = globals.xid or true
    end
    if xstars then
        globals.xstars = globals.xstars or true
    end
    if xmagic then
        globals.xmagic = globals.xmagic or true
    end
    if xeffect then
        globals.xeffect = globals.xeffect or true
    end
    if xmode then
        globals.xmode = globals.xmode or true
    end
    if xamount then
        globals.xamount = globals.xamount or true
    end
else
    -- Do nothing for non-dragonquest mobs
    _return_value = false
end
return _return_value