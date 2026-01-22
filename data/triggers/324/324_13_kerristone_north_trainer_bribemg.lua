-- Trigger: Kerristone_north_trainer_bribeMG
-- Zone: 324, ID: 13
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #32413

-- Converted from DG Script #32413: Kerristone_north_trainer_bribeMG
-- Original: MOB trigger, flags: BRIBE, probability: 42%

-- 42% chance to trigger
if not percent_chance(42) then
    return true
end
-- This is one of the bribe progs that will
-- let players buy a horse to bolt to Mugnork
-- The horse trigs have been altered in concept
-- on how they deliver the players to the destination
-- but there's no reason why this trig can't exist
-- as is to kick it off
if actor.id == -1 then
    wait(1)
    self.room:send(tostring(self.name) .. " says, '</>Ahh Thankyou! You will not be disappointed.</>'")
    self.room:send(tostring(self.name) .. " says, '</>I have one of the fastest </><blue>&9stallions</> in the land for you!'")
    wait(2)
    self.room:send("</>A <yellow>horse</> trainer leads a fine looking <blue>&9stallion</> into the room.")
    self.room:spawn_mobile(324, 23)
    wait(2)
    self.room:send("</>A horse trainer gets under you and pushes you up into the saddle.</>")
    self.room:spawn_object(324, 25)
    self.room:send(tostring(self.name) .. " says, 'Feed him this <red>strawberry</> and he will know that you want to go to <b:cyan>Mugnork</>.'")
    self:command("give strawberry " .. tostring(actor.name))
    wait(2)
    self.room:send("</>A <yellow>horse</> trainer forces your hand towards the mouth of the horse.")
    actor:command("give strawberry stallion")
    self.room:send(tostring(self.name) .. " says, 'Good journey!'")
else
end