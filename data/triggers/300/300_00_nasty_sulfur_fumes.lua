-- Trigger: Nasty sulfur fumes
-- Zone: 300, ID: 0
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #30000

-- Converted from DG Script #30000: Nasty sulfur fumes
-- Original: WORLD trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
local victim = room.actors[random(1, #room.actors)]
if victim == 0 or victim.id ~= -1 then
    return _return_value
end
local damage = 2
-- switch on random(1, 10)
if random(1, 10) == 1 then
    local damage = 1
elseif random(1, 10) == 2 then
    victim:send("You just inhaled a lungful of sulphurous fumes!  It burns!")
    self.room:send_except(victim, tostring(victim.name) .. " inhales a lungful of fumes and chokes and gags!")
    local damage_dealt = victim:damage(damage)  -- type: physical
elseif random(1, 10) == 3 or random(1, 10) == 4 then
    victim:send("The stinking yellow smoke wafts under your nose, making you sneeze.")
    self.room:send_except(victim, tostring(victim.name) .. " breathes in a bit of yellow smoke, and sneezes.")
elseif random(1, 10) == 5 or random(1, 10) == 6 then
    victim:send("Your eyes water from the rotten-smelling smoke.")
    self.room:send_except(victim, tostring(victim.name) .. " blinks as the nasty smoke gets in " .. tostring(victim.possessive) .. " eyes.")
else
    self.room:send("Nasty fumes waft up from the wreckage.  They smell of rotten egs.")
end