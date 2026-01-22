-- Trigger: Sorcerer Quest Spell Hints
-- Zone: 1, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #109

-- Converted from DG Script #109: Sorcerer Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: major major? globe globe? relocate relocate? charm charm? person person? wizard wizard? eye eye?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "major") or string.find(string.lower(speech), "major?") or string.find(string.lower(speech), "globe") or string.find(string.lower(speech), "globe?") or string.find(string.lower(speech), "relocate") or string.find(string.lower(speech), "relocate?") or string.find(string.lower(speech), "charm") or string.find(string.lower(speech), "charm?") or string.find(string.lower(speech), "person") or string.find(string.lower(speech), "person?") or string.find(string.lower(speech), "wizard") or string.find(string.lower(speech), "wizard?") or string.find(string.lower(speech), "eye") or string.find(string.lower(speech), "eye?")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
-- switch on speech
if string.find(self.class, "sorcerer") or string.find(self.class, "pyromancer") or string.find(self.class, "cryomancer") then
    if speech == "major" or speech == "major?" or speech == "globe" or speech == "globe?" then
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
    if string.find(self.class, "sorcerer") or string.find(self.class, "pyromancer") or string.find(self.class, "cryomancer") then
    elseif speech == "relocate" or speech == "relocate?" then
        self:say("A student of Bigby's in Mielikki was working on")
        self.room:send("'A powerful teleportation spell she called <b:magenta>Relocate</>.'")
        -- (empty room echo)
        self.room:send("'Bigby or one of his lab assistants might know more.'")
    else
        self:say("Our Guild doesn't keep records of esoteric")
        self.room:send("'magics exclusive to other guilds. Sorry.'")
    end
    if string.find(self.class, "sorcerer") or string.find(self.class, "illusionist") or string.find(self.class, "bard") then
    elseif speech == "charm" or speech == "charm?" or speech == "person" or speech == "person?" then
        self:say("Charming is both a magical and a personal skill.")
        self.room:send("'<b:magenta>Charm Person</> relies on mixing both.'")
        -- (empty room echo)
        self.room:send("'However, those that make charming others a profession, particularly'")
        self.room:send("'courtesans, are the best teachers.'")
    else
        self:say("As charming as you are, I cannot point you in a")
        self.room:send("'better direction.'")
    end
    if string.find(self.class, "sorcerer") then
    elseif speech == "wizard" or speech == "wizard?" or speech == "eye" or speech == "eye?" then
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
    _return_value = false
end
return _return_value