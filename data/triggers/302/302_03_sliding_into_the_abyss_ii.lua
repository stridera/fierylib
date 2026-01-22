-- Trigger: Sliding into the abyss II
-- Zone: 302, ID: 3
-- Type: WORLD, Flags: RANDOM, POSTENTRY
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #30203

-- Converted from DG Script #30203: Sliding into the abyss II
-- Original: WORLD trigger, flags: RANDOM, POSTENTRY, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
-- Makes players slide off the edge of a precipice, where they'll fall into
-- a ravine and get hurt.
-- Applied to: r30229, r203217
local victim = room.actors[random(1, #room.actors)]
if victim == 0 or victim.id ~= -1 then
    return _return_value
end
local startroom = victim.room
-- Don't bother flying or levitating people.
if victim:has_effect(Effect.Flying) or victim:has_effect(Effect.Feather_Fall) then
    return _return_value
end
-- Consider rangers and druids as too sure-footed to lose their footing.
if victim.class == "Ranger" or victim.class == "Druid" then
    self.room:send_except(victim, "A rock shifts under " .. tostring(victim.name) .. "'s foot, but " .. tostring(victim.name) .. " quickly steps to one side.")
    victim:send("A rock shifts under your foot, and you step to steadier ground.")
    return _return_value
end
wait(4)
if victim.room ~= "startroom" then
    return _return_value
end
self.room:send_except(victim, tostring(victim.name) .. " slips on a loose rock, and begins to slide downward!")
victim:send("Your foot slips on a loose rock.  You are sliding downward!")
wait(3)
if victim.room ~= "startroom" then
    return _return_value
end
self.room:send_except(victim, tostring(victim.name) .. " is sliding straight toward a sheer dropoff!")
victim:send("You are sliding right toward a deep ravine!")
wait(2)
if victim.room ~= "startroom" then
    return _return_value
end
self.room:send_except(victim, tostring(victim.name) .. " disappears off the edge with a yelp!")
victim:send("You slide off the edge into thin air!")
victim:teleport(get_room(302, 51))
-- victim looks around