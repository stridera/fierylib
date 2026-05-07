-- Trigger: waterform_wave_speech2
-- Zone: 28, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: REVIEWED (speech match deduplicated and nil-safe)
--
-- Original DG Script: #2803
-- The Great Wave responds to follow-up questions ("what / elements /
-- things / like") at stage 2 with hints about needing a white dragon bone.

-- Speech keywords: elements / what / things / like
local speech_lower = string.lower(speech or "")
if not (string.find(speech_lower, "elements") or string.find(speech_lower, "what")
        or string.find(speech_lower, "things") or string.find(speech_lower, "like")) then
    return true
end
wait(2)
if actor:get_quest_stage("waterform") == 2 then
    self.room:send(tostring(self.name) .. " says, 'I believe the shield needs more embodied magic to sustain")
    self.room:send("</>a transformation.'")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'To gather this magic though, you'll need an appropriate")
    self.room:send("</>vessel.  I can carve such a thing for you if you bring me the proper materials.")
    self.room:send("</>The best vessels for magic samples come from dragon bone, and the most")
    self.room:send("</>appropriate dragons for working with water are white dragons.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Since this will need to come from <b:cyan>a single bone</>, it will")
    self.room:send("</>need to be a decently sized one.'")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'Bones that large are only found in adult dragons, so")
    self.room:send("</>you'll need to find a <b:cyan>very large white dragon</>.'")
    wait(3)
    self:say("Good luck!")
end