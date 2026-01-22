-- Trigger: lori_dance
-- Zone: 43, ID: 22
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4322

-- Converted from DG Script #4322: lori_dance
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("closes her eyes and lifts her arms above her head.")
wait(3)
self:emote("starts dancing while chanting")
self:say("Step kick kick leap kick touch...")
wait(4)
self:command("sniff")
wait(3)
self:say("Can't start crying again...  I have to focus.")