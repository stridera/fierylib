-- Trigger: tempest_fight
-- Zone: 238, ID: 17
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #23817

-- Converted from DG Script #23817: tempest_fight
-- Original: MOB trigger, flags: FIGHT, probability: 35%

-- 35% chance to trigger
if not percent_chance(35) then
    return true
end
if random(1, 10) < 4 then
    wait(1)
    self.room:send("The electrical charge around the Tempest grows stronger than the air can handle.")
    wait(1)
    self.room:send("Powerful arcs of <b:blue>lightning</> jump from the Tempest Manifest, saturating the air with energy!")
    run_room_trigger(23818)
else
    wait(1)
    self.room:send("Lightning crackles through the Tempest, electrifying the air around its body.")
end