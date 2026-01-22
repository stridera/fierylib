-- Trigger: test_for_nok
-- Zone: 18, ID: 55
-- Type: WORLD, Flags: PREENTRY
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #1855

-- Converted from DG Script #1855: test_for_nok
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor.id == -1 then
    wait(1)
    actor:send("You land with a loud thump on the fiery floor.")
    self.room:send_except(actor, tostring(actor.name) .. " lands on the fiery floor with a loud thump.")
    wait(1)
    actor:send("You feel yourself burning!")
    actor:damage(200)  -- type: physical
    actor.name:shout("Help me!")
    wait(5)
    if actor.room ~= 1841 then
        return _return_value
    end
    actor:send("You feel a burst of flame rip into your skin!")
    self.room:send_except(actor, "A burst of flame rips into " .. tostring(actor.name) .. ", almost burning him alive!")
    actor:damage(100)  -- type: physical
    wait(10)
    if actor.room ~= 1841 then
        return _return_value
    end
    actor:send("You feel a burst of flame rip into your skin!")
    self.room:send_except(actor, "A burst of flame rips into " .. tostring(actor.name) .. ", almost burning him alive!")
    actor:damage(100)  -- type: physical
    wait(15)
    if actor.room ~= 1841 then
        return _return_value
    end
    actor.name:shout("help, I'm burning!")
    wait(1)
    if actor.room ~= 1841 then
        return _return_value
    end
    actor:send("You feel a burst of flame rip into your skin!")
    self.room:send_except(actor, "A burst of flame rips into " .. tostring(actor.name) .. ", almost burning him alive!")
    actor:damage(100)  -- type: physical
    wait(20)
    if actor.room ~= 1841 then
        return _return_value
    end
    actor:send("The flames consume you.")
    self.room:send_except(actor, "The searing flames consume " .. tostring(actor.name) .. ".")
    actor:damage(1000)  -- type: physical
end