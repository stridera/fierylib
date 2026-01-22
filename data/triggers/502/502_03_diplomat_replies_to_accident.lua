-- Trigger: Diplomat replies to 'accident'
-- Zone: 502, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #50203

-- Converted from DG Script #50203: Diplomat replies to 'accident'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: accident accident?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "accident") or string.find(string.lower(speech), "accident?")) then
    return true  -- No matching keywords
end
wait(2)
self.room:send(tostring(self.name) .. " says, 'Yes, the horrible storm that wrecked our ships.")
self.room:send("</>It was horrendous and unnatural.  I have long wondered what evil magic")
self.room:send("</>spawned it, for the seas of Ethilien could scarce have birthed such a monster")
self.room:send("</>on their own.'")
wait(6)
self:emote("looks pensive.")
wait(4)
self.room:send(tostring(self.name) .. " says, 'After our ships wrecked, the captain was")
self.room:send("</>obsessed with finding some magical bauble or other -- he wouldn't say what,")
self.room:send("</>exactly -- and though he was fairly unscathed, he would render little help")
self.room:send("</>to the injured around him.  He disappeared soon after, leaving the rest of")
self.room:send("</>us to die.'")
wait(6)
self:command("sigh")
wait(4)
self.room:send(tostring(self.name) .. " says, 'If only I knew what it was, perhaps I could")
self.room:send("</>free us from this unnatural bondage.  If you come across such a thing, would")
self.room:send("</>you be so kind as to allow me to examine it?'")