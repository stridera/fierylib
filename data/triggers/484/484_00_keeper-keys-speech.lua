-- Trigger: keeper-keys-speech
-- Zone: 484, ID: 0
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #48400

-- Converted from DG Script #48400: keeper-keys-speech
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
actor:send(tostring(self.name) .. " eyes you mercilessly.")
self.room:send_except(actor, tostring(self.name) .. " eyes " .. tostring(actor.name) .. " mercilessly.")
wait(1)
if actor.level < 85 then
    actor:send(tostring(self.name) .. " says to you, 'You are far too weak to seek entry into")
    actor:send("</>the elemental planes.  Come back when you are stronger.'")
    self.room:send_except(actor, tostring(self.name) .. " says to " .. tostring(actor.name) .. ", 'You are far too weak to seek")
    self.room:send_except(actor, "</>entry into the elemental planes.  Come back when you are stronger.'")
elseif actor:get_quest_stage("doom_entrance") < 1 then
    self.room:send(tostring(self.name) .. " says, 'So, " .. tostring(actor.name) .. ", you wish to seek entry into")
    self.room:send("</>Lokari's Keep?'")
elseif actor:get_has_completed("doom_entrance") then
    self.room:send(tostring(self.name) .. " says, 'Well done, " .. tostring(actor.name) .. "!")
    self.room:send("</>Please take this key and with it our hopes.'")
    self.room:spawn_object(484, 1)
    self:command("give sacred-key " .. tostring(actor.name))
    self:command("bow")
    self:say("Use it well!")
end