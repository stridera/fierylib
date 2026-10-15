-- Trigger: Druid responds to 'yes'
-- Zone: 120, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12001

-- Converted from DG Script #12001: Druid responds to 'yes'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(1)
if actor:get_has_completed("twisted_sorrow") then
    self:command("smile " .. actor.name)
    wait(1)
    self:say("The trees are satisfied, my friend.")
else
    actor:send(self.name .. " looks over you carefully.")
    self.room:send_except(actor, self.name .. " looks over " .. actor.name .. " carefully.")
    wait(2)
    self.room:send("The hooded druid says, 'You seem the bright sort, and I sense some compassion")
    self.room:send("</>in you.  If you can muster the kindness to minister to the sorrow that these")
    self.room:send("</>trees bear, who knows what good shall follow?  Surely, the curse upon this")
    self.room:send("</>forest cannot so easily be lifted, but still, kind deeds never go wasted in")
    self.room:send("</>this world.'")
    wait(5)
    self:emote("thinks deeply for a moment.")
    wait(2)
    self.room:send("The hooded druid asks, 'So: would you care to ease the loneliness of the")
    self.room:send("</>Rhells?  If you wish to do so, say <b:white>\"I will assist\"</>.'")
end