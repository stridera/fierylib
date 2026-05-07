-- Trigger: hot-spring
-- Zone: 103, ID: 8
-- Type: WORLD, Flags: RANDOM, SPEECH, PREENTRY
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #10308
-- A multi-purpose hot-spring effect that deals heat damage to any
-- non-pyromancer, non-heat-resistant player in the room.
--
-- Fires on RANDOM ticks, on any speech (DG keyword "." = substring
-- match, accepts everything), and on PREENTRY of a new mover. The
-- DG narg of 100 is the RANDOM % chance.
--
-- TODO(parity): the DG fallback `if !%actor%; set actor %random.char%`
-- handles RANDOM ticks where no actor is bound. The runtime currently
-- always binds `actor` for SPEECH/PREENTRY but the RANDOM path may
-- pass nil; we mirror the legacy fallback by picking a random
-- non-mob occupant if `actor` is unset.

local who = actor
if not who then
    if room and room.actors and #room.actors > 0 then
        who = room.actors[random(1, #room.actors)]
    end
end
if not who or not who.is_player then
    return true
end

local heat_resistant = who:has_effect(Effect.HeatResistance)
if who.class == "Pyromancer" or heat_resistant then
    return true
end

local damage = random(1, 10) + random(1, 10)
self.room:send_except(who, who.name .. " starts to look a bit woozy from the extreme heat.")
who:send("The water is too hot for you....")
who:damage(damage)  -- physical heat damage
return true
