-- Trigger: hell_gate_diabolist_speech1
-- Zone: 564, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #56401
--
-- "yes" reply to the diabolist's greet question. For Diabolist class
-- on stage 0, gates the quest start path on level >= 80. For anyone
-- already in the quest (stage > 0), prompts the per-stage check.

-- Speech keyword: "yes"
if not string.find(string.lower(speech), "yes") then
    return true
end
wait(2)
if string.find(actor.class, "Diabolist") and actor:get_quest_stage("hell_gate") == 0 then
    if actor.level > 80 then
        self.room:send(tostring(self.name) .. " says, 'Then it must be our fate to open the gates of")
        self.room:send("</>Hell together.  Come, <b:white>[enter]</> the <b:white>[circle]</> and join me.'")
    else
        self.room:send(tostring(self.name) .. " says, 'Interesting...")
        self.room:send("</>You are not yet strong enough to join me in my task.  Continue your journey'")
        self.room:send("</>and return when you are more experienced.'")
    end
elseif actor:get_quest_stage("hell_gate") > 0 then
    self:say("Let me see!")
end