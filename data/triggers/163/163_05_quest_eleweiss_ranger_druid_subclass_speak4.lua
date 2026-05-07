-- Trigger: quest_eleweiss_ranger_druid_subclass_speak4
-- Zone: 163, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16305

-- Player asks "what is the lost something?" — Eleweiss reveals it was the
-- jewel of his heart and advances them from stage 2 -> 3.

local sl = string.lower(speech)
if not (string.find(sl, "something") or string.find(sl, "lost") or string.find(sl, "it")
    or string.find(sl, "thing") or string.find(sl, "what")) then
    return true
end
wait(2)
if actor:get_quest_stage("ran_dru_subclass") == 2 then
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'It seems I am becoming forgetful in my age.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Well, you see now, I lost the jewel of my heart.  If you are up to it, getting that and returning it to me will get you your reward.'")
    self:command("shrug")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'But for now, it is time for you to depart I think.'")
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'You have brought up painful memories for me to relive.'")
    actor:advance_quest("ran_dru_subclass")
end