-- Trigger: Cryomancer Quest Spell Hints
-- Zone: 1, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #110

-- Converted from DG Script #110: Cryomancer Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: waterform waterform? flood flood? ice ice? shards shards? water water? form form? wall wall?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "waterform") or string.find(string.lower(speech), "waterform?") or string.find(string.lower(speech), "flood") or string.find(string.lower(speech), "flood?") or string.find(string.lower(speech), "ice") or string.find(string.lower(speech), "ice?") or string.find(string.lower(speech), "shards") or string.find(string.lower(speech), "shards?") or string.find(string.lower(speech), "water") or string.find(string.lower(speech), "water?") or string.find(string.lower(speech), "form") or string.find(string.lower(speech), "form?") or string.find(string.lower(speech), "wall") or string.find(string.lower(speech), "wall?")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
-- switch on speech
if string.find(self.class, "cryomancer") then
    if speech == "waterform" or speech == "waterform?" or speech == "water" or speech == "water?" or speech == "form" or speech == "form?" then
        self.room:send(tostring(self.name) .. " says, '<b:blue>Waterform</> is more absorbed via osmosis than")
        self.room:send("'taught in the traditional sense. The spell is typically imparted by powerful'")
        self.room:send("'water elementals.'")
        -- (empty room echo)
        self.room:send("'You can find such elementals in the vast lakes and rivers of Ethilien.'")
    else
        self:say("That spell is unique to the Cryomancer's Guild.")
    end
    if string.find(self.class, "cryomancer") then
    elseif speech == "ice" or speech == "ice?" or speech == "shards" or speech == "shards?" then
        self.room:send(tostring(self.name) .. " says, 'Unfortunately, <b:cyan>Ice Shards</>'")
        self.room:send("'has been lost to our guild for many centuries. Khysan, a cyromancer from a'")
        self.room:send("'smaller branch of the elven Sunfire family, has been doing research into the'")
        self.room:send("'last known records of the spell, but hasn't reported any findings or updates'")
        self.room:send("'in many years.'")
        -- (empty room echo)
        self.room:send("'Perhaps you could check in with him. He works at the springs.'")
    else
        self:say("I've heard even the cryomancers don't know where")
        self.room:send("'to look for that spell. There's no chance anyone in our Guild would know.'")
    end
    if string.find(self.class, "cryomancer") then
    elseif speech == "flood" or speech == "flood?" then
        self:say("The power to call the roaring waters of Ethilien")
        self.room:send("'in a cataclysmic <b:blue>Flood</> is taught by the ocean herself. You would be")
        self.room:send("'either very lucky or very cursed to find her avatar.")
    elseif string.find(self.class, "druid") then
        self:say("We commune with the waters of the world in a very,")
        self.room:send("'very different way.'")
    else
        self:say("Unfortunately I don't have any guidance for you.")
    end
    if string.find(self.class, "cryomancer") then
        if string.find(actor.class, "cryomancer") then
        elseif speech == "wall" or speech == "wall?" then
            self:say("They regularly make use of <b:cyan>Wall of Ice</> to")
            self.room:send("'keep The most dangerous creatures from Frost Valley out of Mount Frostbite.'")
            -- (empty room echo)
            self.room:send("'Someone up there will know what to do.'")
        elseif string.find(actor.class, "illusionist") then
            self.room:send(tostring(self.name) .. " says, 'There is an <b:magenta>Illusory Wall</> spell out there,'")
            self.room:send("'but I don't know much about it.'")
        end
    elseif string.find(self.class, "illusionist") then
        if string.find(actor.class, "illusionist") then
            self:say("The best teacher of <b:magenta>Illusory Wall</> was a Post Commander")
            self.room:send("'for the Eldorian Guard.'")
            -- (empty room echo)
            self.room:send("'I hear she retired to the far north.'")
        elseif string.find(actor.class, "cryomancer") then
            self.room:send(tostring(self.name) .. " says, 'Your <b:cyan>Wall of Ice</> spell is extremely similar to our wall'")
            self.room:send("'spell, but I don't know much about it.'")
        end
    else
        self:say("Wall spells are not part of our Guild teachings.")
    end
else
    _return_value = false
end
return _return_value