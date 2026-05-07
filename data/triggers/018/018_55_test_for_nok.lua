-- Trigger: test_for_nok
-- Zone: 18, ID: 55
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1855

-- Converted from DG Script #1855: test_for_nok
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor.is_player then
    wait(1)
    actor:send("You land with a loud thump on the fiery floor.")
    self.room:send_except(actor, tostring(actor.name) .. " lands on the fiery floor with a loud thump.")
    wait(1)
    actor:send("You feel yourself burning!")
    actor:damage(200)  -- type: physical
    actor:shout("Help me!")
    wait(5)
    if not (actor.room and actor.room.zone_id == 18 and actor.room.local_id == 41) then
        return true
    end
    actor:send("You feel a burst of flame rip into your skin!")
    self.room:send_except(actor, "A burst of flame rips into " .. tostring(actor.name) .. ", almost burning him alive!")
    actor:damage(100)  -- type: physical
    wait(10)
    if not (actor.room and actor.room.zone_id == 18 and actor.room.local_id == 41) then
        return true
    end
    actor:send("You feel a burst of flame rip into your skin!")
    self.room:send_except(actor, "A burst of flame rips into " .. tostring(actor.name) .. ", almost burning him alive!")
    actor:damage(100)  -- type: physical
    wait(15)
    if not (actor.room and actor.room.zone_id == 18 and actor.room.local_id == 41) then
        return true
    end
    actor:shout("help, I'm burning!")
    wait(1)
    if not (actor.room and actor.room.zone_id == 18 and actor.room.local_id == 41) then
        return true
    end
    actor:send("You feel a burst of flame rip into your skin!")
    self.room:send_except(actor, "A burst of flame rips into " .. tostring(actor.name) .. ", almost burning him alive!")
    actor:damage(100)  -- type: physical
    wait(20)
    if not (actor.room and actor.room.zone_id == 18 and actor.room.local_id == 41) then
        return true
    end
    actor:send("The flames consume you.")
    self.room:send_except(actor, "The searing flames consume " .. tostring(actor.name) .. ".")
    actor:damage(1000)  -- type: physical
end