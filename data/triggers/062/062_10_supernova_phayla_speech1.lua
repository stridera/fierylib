-- Trigger: supernova_phayla_speech1
-- Zone: 62, ID: 10
-- Type: MOB, Flags: SPEECH
--
-- Phayla's reply when a stage-7 supernova questor asks her about supernova /
-- teaching: she demands the miniature sun (510, 73) and Phayla's lamp
-- (489, 17) up front before instructing them.
--
-- Original DG Script: #6210

if not (string.find(string.lower(speech), "supernova")
        or string.find(string.lower(speech), "super")
        or string.find(string.lower(speech), "nova")
        or string.find(string.lower(speech), "teach")) then
    return true
end
wait(2)
if actor:get_quest_stage("supernova") == 7 then
    self:command("roll")
    self:say("Of course that's what you want.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'No one ever comes just to ask, \"How are you?  How's your day")
    self.room:send("</>going?\"  Oh no, they always want something.  No sense of class or decorum.'")
    self:command("sigh")
    wait(2)
    self:say("Alright, I'll teach you.")
    wait(1)
    self:say("But payment upfront.  Give me that miniature sun you found.")
    wait(2)
    actor:send(tostring(self.name) .. " shoots you with a harsh, critical look.")
    self.room:send_except(actor, tostring(self.name) .. " shoots " .. tostring(actor.name) .. " a harsh, critical look.")
    wait(1)
    self:say("Hand over the lamp too.  Don't think you deserve to have that...")
end