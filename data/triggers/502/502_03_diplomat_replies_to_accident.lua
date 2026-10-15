-- Trigger: Diplomat replies to 'accident'
-- Zone: 502, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #50203

-- Converted from DG Script #50203: Diplomat replies to 'accident'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"accident", "accident?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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