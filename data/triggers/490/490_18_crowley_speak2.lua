-- Trigger: crowley_speak2
-- Zone: 490, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49018

-- Converted from DG Script #49018: crowley_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: the seer requests your assistance (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "the seer requests your assistance", 1, true) then
    return true  -- Not the phrase
end
wait(2)
self:set_flag("sentinel", true)
if actor:get_quest_stage("griffin_quest") < 3 then
    self:say("Oh, does she now?  Are you certain?")
    self:command("peer " .. tostring(actor.name))
elseif actor.is_player then
    self:say("Oh, I had hoped this would never happen.")
    self:command("hiccup")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'I suppose she told you that I know where the cult's chapel is?'")
    self:command("sigh")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I rolled a boulder over the entrance and persuaded Derceta to guard it.  I used to be quite strong in my youth.'")
    self:command("strut")
    wait(2)
    self:say("But drink has done away with that.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'In fact, the only person who I can think of who could possibly move it would be Derceta.  I suggest you ask her to help move the boulder.'")
    wait(3)
    self:emote("takes a swig from his waterskin.")
    self:say("Ah, the drink helps me forget, but not for long.")
end
self:set_flag("sentinel", false)