-- Trigger: ice_shards_slevvirik_speech
-- Zone: 103, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10316

-- Converted from DG Script #10316: ice_shards_slevvirik_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: butcher
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "butcher")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("ice_shards") == 5 then
    actor.name:advance_quest("ice_shards")
    wait(2)
    self:command("sigh")
    self.room:send(tostring(self.name) .. " says, 'Yes, I do know where he is and before you ask, no I don't mind")
    self.room:send("</>telling you.  My contractual obligation to him is fulfilled and if I do tell")
    self.room:send("</>you where he is, I doubt it will make much of a difference.'")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'That beast knew his reputation was going to catch up to him")
    self.room:send("</>sooner or later.  He paid us to hide him where no one in the world would find")
    self.room:send("</>him.  So we hid him off world.'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'We opened a gateway to the Plane of Earth and sent him on his")
    self.room:send("</>way.  I suppose he's still there.'")
    wait(4)
    self:say("If he's still alive.")
    wait(1)
    self:command("tip " .. tostring(actor))
end