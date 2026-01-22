-- Trigger: Kerristone_north_trainer_bribe_mh
-- Zone: 324, ID: 14
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #32414

-- Converted from DG Script #32414: Kerristone_north_trainer_bribe_mh
-- Original: MOB trigger, flags: BRIBE, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
-- This is one of the bribe trigs that will
-- let a player buy a horse to take them to
-- morgan hill.  The horse portion will change
-- radically from the prog format but will
-- achieve the same goals.
if actor.id == -1 then
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Ahh Thankyou! You will not be disappointed.'")
    self.room:send(tostring(self.name) .. " says, 'I have one of the fastest horses in the land for you!'")
    wait(2)
    self.room:send("</>The <yellow>horse</> trainer leads a fine looking horse into the room.</>")  -- from MPROG
    self.room:spawn_mobile(324, 21)
    self.room:send("</>The <yellow>horse</> trainer gets under you and pushes you up into the saddle.</>")
    wait(2)
    self.room:spawn_object(324, 21)
    self.room:send(tostring(self.name) .. " says, '</>Feed him this </><yellow>carrot</> and he will know that you want to go to Morgan Hill.</>'")
    self:command("give carrot " .. tostring(actor.name))
    self.room:send("</>The <yellow>horse</> trainer forces your hand towards the mouth of the <yellow>horse</>.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Good journey!'")
else
end