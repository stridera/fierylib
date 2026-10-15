-- Trigger: ***UNUSED***
-- Zone: 237, ID: 24
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23724

-- Converted from DG Script #23724: ***UNUSED***
-- Original: MOB trigger, flags: SPEECH, probability: 100%
-- Marked unused in original codebase; logic mirrors 23722/23723 (yes/no branches).

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("sunfire_rescue") == 1 then
    -- Responding to trigger 23723 in the rescue quest.
    -- I figure he'd be able to tell the difference between cursed items
    -- and besides it's harder to get them all individually.
    -- Fairly straightforward...
    if speech_word == "yes" then
        if actor.alignment > 349 then
            actor:start_quest("sunfire_rescue")
            self:emote("smiles brightly at " .. tostring(actor.name) .. " and looks hopeful.")
            self:say("Thank you! Please return to me with the items and I will be most grateful.")
            self:emote("pauses a moment.")
            self:say("Oh, do not bother with the cursed items.  I can tell the difference.")
            self.room:send("The prisoner looks apprehensive.")
            self:whisper(actor, "You should leave here before the guards come!")
            self:emote("relaxes back into a position of pain, though he smiles at you.")
        end
    end
    if speech_word == "no" then
        self:emote("frowns at " .. tostring(actor.name) .. " stormily.")
        self:say("Then waste my time no more, and begone!")
        actor:move("north")
        -- Oooh, he gets really mad here.
    end
end