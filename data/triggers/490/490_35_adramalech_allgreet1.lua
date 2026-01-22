-- Trigger: adramalech_allgreet1
-- Zone: 490, ID: 35
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #49035

-- Converted from DG Script #49035: adramalech_allgreet1
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if actor.id == -1 and actor.level < 100 then
    self:emote("throws his head back and laughs a deep booming laugh.")
    self.room:send(tostring(self.name) .. " says, 'So " .. tostring(actor.name) .. ", my form in your plane has been destroyed")
    self.room:send("</>for now, but this is MY domain.'")
    wait(1)
    self:emote("grins an evil grin, showing a lot of teeth.")
    self:say("Perhaps I will invite a few friends to help me destroy you.")
end