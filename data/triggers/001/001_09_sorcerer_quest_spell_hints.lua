-- Trigger: Sorcerer Quest Spell Hints
-- Zone: 1, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: PARTIAL
--
-- TODO(parity): converter produced empty `if class-match then` branches followed
-- by `elseif speech == ...` for each hint group. The speech replies only fire
-- when the speaker class does NOT match the gating class. Likely inverse of
-- original intent; needs DG source review.
--
-- Original DG Script: #109

-- Converted from DG Script #109: Sorcerer Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"major", "major?", "globe", "globe?", "relocate", "relocate?", "charm", "charm?", "person", "person?", "wizard", "wizard?", "eye", "eye?"}) do
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
    if _sw1 == "major" or _sw1 == "major?" or _sw1 == "globe" or _sw1 == "globe?" then
        if string.find(self.class, "sorcerer") or string.find(self.class, "pyromancer") or string.find(self.class, "cryomancer") then
            self:say("The battle mage Lirne was talking about")
            self.room:send("'developing a new spell called <b:blue>Major Globe</> to defend himself against'")
            self.room:send("'powerful magicians.'")
            -- (empty room echo)
            self.room:send("'Last I heard, he was going to test it out against a powerful demonic agent of'")
            self.room:send("'chaos in the far north.'")
        else
            self:say("I'm afraid Major Globe isn't a spell I know how")
            self.room:send("'to cast.'")
        end
    elseif _sw1 == "relocate" or _sw1 == "relocate?" then
        if string.find(self.class, "sorcerer") or string.find(self.class, "pyromancer") or string.find(self.class, "cryomancer") then
            self:say("A student of Bigby's in Mielikki was working on")
            self.room:send("'A powerful teleportation spell she called <b:magenta>Relocate</>.'")
            -- (empty room echo)
            self.room:send("'Bigby or one of his lab assistants might know more.'")
        else
            self:say("Our Guild doesn't keep records of esoteric")
            self.room:send("'magics exclusive to other guilds. Sorry.'")
        end
    elseif _sw1 == "charm" or _sw1 == "charm?" or _sw1 == "person" or _sw1 == "person?" then
        if string.find(self.class, "sorcerer") or string.find(self.class, "illusionist") or string.find(self.class, "bard") then
            self:say("Charming is both a magical and a personal skill.")
            self.room:send("'<b:magenta>Charm Person</> relies on mixing both.'")
            -- (empty room echo)
            self.room:send("'However, those that make charming others a profession, particularly'")
            self.room:send("'courtesans, are the best teachers.'")
        else
            self:say("As charming as you are, I cannot point you in a")
            self.room:send("'better direction.'")
        end
    elseif _sw1 == "wizard" or _sw1 == "wizard?" or _sw1 == "eye" or _sw1 == "eye?" then
        if string.find(self.class, "sorcerer") then
            self:say("A simple but highly effective spell! The shamans of the")
            self.room:send("'Great Snow Leopard are particularly adept At teaching <b:cyan>Wizard Eye</> to'")
            self.room:send("'interested scholars.'")
            -- (empty room echo)
            self.room:send("'Seek them out to learn more.'")
        else
            self:say("That is a highly exclusive sorcerer spell. I am")
            self.room:send("'unable to help with that.'")
        end
    else
        _return_value = true
    end
end
return _return_value