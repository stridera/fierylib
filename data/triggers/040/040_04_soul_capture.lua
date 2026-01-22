-- Trigger: soul capture
-- Zone: 40, ID: 4
-- Type: OBJECT, Flags: RANDOM, COMMAND
-- Status: CLEAN
--   Note: Logic uses globals for state persistence across calls
--
-- Original DG Script: #4004

-- Converted from DG Script #4004: soul capture
-- Original: OBJECT trigger, flags: RANDOM, COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: kill hit cast kick backstab
if not (cmd == "kill" or cmd == "hit" or cmd == "cast" or cmd == "kick" or cmd == "backstab") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
wait(1)
local player = self.worn_by
if player.is_fighting then
    if player.is_fighting == "victim" then
    else
        self.room:send("reseting variables")
        local victim = player.is_fighting
        local soul = victim.name
        local heal = (victim.level * 5) + random(1, 10)
        local validate = 0
        globals.victim = globals.victim or true
        globals.soul = globals.soul or true
        globals.heal = globals.heal or true
        globals.validate = globals.validate or true
    end
else
    return _return_value
end
local health = victim.hit / victim.maxhit * 100
if validate == 2 then
    if victim == 0 then
        player:send("<red>The soul of " .. tostring(soul) .. " is captured by the ring of souls.</> (<b:green>" .. tostring(heal) .. "</>)")
        player:heal(heal)
    elseif health <= 5 then
        local damage_dealt = victim:damage(victim.hit)  -- type: physical
        player:heal(heal)
        player:send("<b:red>" .. tostring(soul) .. "'s soul is torn from its mortal frame.</> (<yellow>" .. tostring(damage_dealt) .. "</>) (<b:green>" .. tostring(heal) .. "</>)")
    else
        return _return_value
    end
    validate = nil
    victim = nil
elseif validate == 1 then
    if health <= 20 then
        local validate = 2
        globals.validate = globals.validate or true
        player:send("<magenta>You feel the ring of souls work more deeply on " .. tostring(victim.name) .. ".</>")
    end
elseif validate == 0 then
    if health >= 50 then
        local validate = 1
        globals.validate = globals.validate or true
        player:send("<magenta>You feel the ring of souls begin to work on " .. tostring(victim.name) .. ".</>")
    end
end
return _return_value