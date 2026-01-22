-- Trigger: hell_gate_diabolist_greet
-- Zone: 564, ID: 0
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #56400

-- Converted from DG Script #56400: hell_gate_diabolist_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local stage = actor:get_quest_stage("hell_gate")
if string.find(actor.class, "Diabolist") and stage == 0 then
    self:command("bow " .. tostring(actor))
    self.room:send(tostring(self.name) .. " says, 'Welcome, dark disciple.")
    self.room:send("Has the hellish realm Garl'lixxil called you here as well?'")
elseif string.find(actor.class, "Paladin") or string.find(actor.class, "Priest") then
    self:say("You are not welcome here!")
    combat.engage(self, actor.name)
end
if stage == 1 then
    self:say("Have you found the spider-shaped dagger?")
elseif stage == 2 then
    self:say("Have you been able to locate the seven keys?")
elseif stage == 3 then
    self.room:send(tostring(self.name) .. " says, 'Ah, have you returned with the blood of the")
    self.room:send("sacrifices? <b:white>[Drop]</> it on the ground.'")
elseif stage == 4 then
    self:say("Give me the dagger to finish the rite.")
elseif stage == 5 then
    self:say("Quickly, slay Larathiel!")
end