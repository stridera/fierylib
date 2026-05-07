-- Trigger: Nukreth Spire ambush
-- Zone: 462, ID: 28
-- Type: WORLD, Flags: POSTENTRY
-- Status: CLEAN
--
-- Original DG Script: #46228

-- Converted from DG Script #46228: Nukreth Spire ambush
-- Original: WORLD trigger, flags: POSTENTRY, probability: 100%
if actor.zone_id == 462 and (actor.local_id == 20 or actor.local_id == 21 or actor.local_id == 22 or actor.local_id == 23) then
    wait(2)
    -- TODO(parity): legacy DG had captive `follow(me)` which referenced the
    -- triggering room actor. We omit it; the captive should already be
    -- following the leader from the receive/follow_me triggers.
    self.room:send("Two gnoll trackers leap out of the shadows and attack!")
    self.room:send("A gnoll tracker says, 'Devour it before it escapes!!'")
    self.room:spawn_mobile(462, 1)
    self.room:spawn_mobile(462, 1)
    self.room:find_actor("captive"):say("Help me!!")
end