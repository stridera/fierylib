-- Trigger: crowley_speak2
-- Zone: 490, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49018

-- Converted from DG Script #49018: crowley_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: the seer requests your assistance
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "the") or string.find(string.lower(speech), "seer") or string.find(string.lower(speech), "requests") or string.find(string.lower(speech), "your") or string.find(string.lower(speech), "assistance")) then
    return true  -- No matching keywords
end
wait(2)
self:set_flag("sentinel", true)
if actor:get_quest_stage("griffin_quest") < 3 then
    self:say("Oh, does she now?  Are you certain?")
    self:command("peer " .. tostring(actor.name))
elseif actor.id == -1 then
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