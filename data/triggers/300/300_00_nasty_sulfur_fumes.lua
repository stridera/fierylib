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
if #self.room.actors == 0 then
    return true
end
local victim = self.room.actors[random(1, #self.room.actors)]
if not victim or victim.is_npc then
    return true
end
-- single roll, branched (legacy DG used switch which evaluated once)
local roll = random(1, 10)
if roll == 1 then
    -- light sting, no damage message yet
    victim:send("Acrid fumes briefly sting your eyes.")
elseif roll == 2 then
    victim:send("You just inhaled a lungful of sulphurous fumes!  It burns!")
    self.room:send_except(victim, tostring(victim.name) .. " inhales a lungful of fumes and chokes and gags!")
    victim:damage(2)  -- physical
elseif roll == 3 or roll == 4 then
    victim:send("The stinking yellow smoke wafts under your nose, making you sneeze.")
    self.room:send_except(victim, tostring(victim.name) .. " breathes in a bit of yellow smoke, and sneezes.")
elseif roll == 5 or roll == 6 then
    victim:send("Your eyes water from the rotten-smelling smoke.")
    self.room:send_except(victim, tostring(victim.name) .. " blinks as the nasty smoke gets in " .. tostring(victim.possessive) .. " eyes.")
else
    self.room:send("Nasty fumes waft up from the wreckage.  They smell of rotten eggs.")
end
return true