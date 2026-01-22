-- Trigger: ice_shards_khysan_speech2
-- Zone: 103, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10311

-- Converted from DG Script #10311: ice_shards_khysan_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: lost lost?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "lost") or string.find(string.lower(speech), "lost?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Cryomancer") then
    wait(2)
    self:command("nod")
    self.room:send(tostring(self.name) .. " says, 'Even my elven family, the Sunfire clan, has lost the")
    self.room:send("</>secrets to the spell.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Legend has it the last copy of Ice Shards was in the")
    self.room:send("</>fabled lost library of Shiran.  But perhaps the spell survived in some ancient")
    self.room:send("</>text.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'I've heard of four books that could potentially hold the information:'")
    self.room:send("<b:yellow>the Book of Kings</>")
    self.room:send("<b:yellow>the Book of Discipline</>")
    self.room:send("<b:yellow>The Xapizan Codex</>")
    self.room:send("<b:yellow>the Enchiridion</>")
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'Maybe if I could get my hands on each of them, between")
    self.room:send("</>them I could piece together fragments of the spell!'")
    wait(3)
    self:say("Will you track down these books and bring them to me?")
end