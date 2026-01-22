-- Trigger: rock_monster_converting
-- Zone: 481, ID: 5
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48105

-- Converted from DG Script #48105: rock_monster_converting
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: p I can feel the magic working!
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "p") or string.find(string.lower(speech), "i") or string.find(string.lower(speech), "can") or string.find(string.lower(speech), "feel") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "magic") or string.find(string.lower(speech), "working!")) then
    return true  -- No matching keywords
end
-- this trigger only works if the rock-monster said the phrase
if actor.id == 48127 then
    wait(2)
    self.room:send("There is a swirling in the air and you see a face appear.")
    self.room:send("The face grins unpleasantly and then cackles.")
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