-- Trigger: Cryomancer Quest Spell Hints
-- Zone: 1, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: PARTIAL
--
-- TODO(parity): converter produced empty `if class-match then` branches followed
-- by `elseif speech == ...` for each hint group. The speech replies only fire
-- when the speaker class does NOT match the gating class. Likely inverse of
-- original intent; needs DG source review.
--
-- Original DG Script: #110

-- Converted from DG Script #110: Cryomancer Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"waterform", "waterform?", "flood", "flood?", "ice", "ice?", "shards", "shards?", "water", "water?", "form", "form?", "wall", "wall?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
-- switch on speech
do
    local _sw1 = string.lower(tostring(speech or ""))
    if _sw1 == "waterform" or _sw1 == "waterform?" or _sw1 == "water" or _sw1 == "water?" or _sw1 == "form" or _sw1 == "form?" then
        if string.find(self.class, "cryomancer") then
            self.room:send(tostring(self.name) .. " says, '<b:blue>Waterform</> is more absorbed via osmosis than")
            self.room:send("'taught in the traditional sense. The spell is typically imparted by powerful'")
            self.room:send("'water elementals.'")
            -- (empty room echo)
            self.room:send("'You can find such elementals in the vast lakes and rivers of Ethilien.'")
        else
            self:say("That spell is unique to the Cryomancer's Guild.")
        end
    elseif _sw1 == "ice" or _sw1 == "ice?" or _sw1 == "shards" or _sw1 == "shards?" then
        if string.find(self.class, "cryomancer") then
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
    elseif _sw1 == "flood" or _sw1 == "flood?" then
        if string.find(self.class, "cryomancer") then
            self:say("The power to call the roaring waters of Ethilien")
            self.room:send("'in a cataclysmic <b:blue>Flood</> is taught by the ocean herself. You would be")
            self.room:send("'either very lucky or very cursed to find her avatar.")
        elseif string.find(self.class, "druid") then
            self:say("We commune with the waters of the world in a very,")
            self.room:send("'very different way.'")
        else
            self:say("Unfortunately I don't have any guidance for you.")
        end
    elseif _sw1 == "wall" or _sw1 == "wall?" then
        if string.find(self.class, "cryomancer") then
            if string.find(actor.class, "cryomancer") then
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
        _return_value = true
    end
end
return _return_value