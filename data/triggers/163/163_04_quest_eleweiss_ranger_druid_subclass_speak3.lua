-- Trigger: quest_eleweiss_ranger_druid_subclass_speak3
-- Zone: 163, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16304

-- Player asks about the "quest" — Eleweiss tells them he lost something
-- and advances them from stage 1 -> 2.

if not string.find(speech, "quest") then
    return true
end
wait(2)
if actor:get_quest_stage("ran_dru_subclass") == 1 then
    actor:advance_quest("ran_dru_subclass")
    actor:send(tostring(self.name) .. " says, 'Yes, quest.  I do suppose it would help if I told you about it.'")
    self:emote("rubs his chin thoughtfully.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Long ago I <b:cyan>lost something</>.  It is a shame, but it has never been recovered.'")
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'If you were to help me with that, then we could arrange something.'")
    self:emote("looks hopeful.")
end