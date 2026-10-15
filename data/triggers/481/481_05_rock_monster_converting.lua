-- Trigger: rock_monster_converting
-- Zone: 481, ID: 5
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48105

-- Converted from DG Script #48105: rock_monster_converting
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"p", "i", "can", "feel", "the", "magic", "working!", "working"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- this trigger only works if the rock-monster said the phrase
if actor.zone_id == 481 and actor.local_id == 27 then
    wait(2)
    self.room:send("There is a swirling in the air and you see a face appear.")
    self.room:send("The face grins unpleasantly then cackles.")
    wait(1)
    self.room:send("The apparition says 'So, you dare to challenge Lokari?!'")
    self.room:send("The apparition glares at you.")
    wait(1)
    self.room:send("The apparition says 'That was a pathetic piece of magic, did you think you could break my spell?  But I will remember that you tried...'")
    wait(1)
    self.room:find_actor("rock-monster"):emote("wails in fear and pain as the transformation reasserts itself.")
    wait(1)
    self.room:find_actor("rock-monster"):emote("turns to you in the instant before it returns to a pile of rock.")
    self.room:find_actor("rock-monster"):command("mecho the rock monster says, 'Please kill me, and take the key I bear to Vulcera, my true love.'")
    wait(1)
    self.room:send("The apparition says 'Pah, she could never love a mortal, your hearts are all made of stone.'")
    self.room:send("The apparition laughs at his own joke and fades.")
end