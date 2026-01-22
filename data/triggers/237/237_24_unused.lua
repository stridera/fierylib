-- Trigger: ***UNUSED***
-- Zone: 237, ID: 24
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23724

-- Converted from DG Script #23724: ***UNUSED***
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("sunfire_rescue") == 1 then
    -- Responding to trigger 23723 in the rescue quest.
    -- I figure he'd be able to tell the difference between cursed items
    -- and besides it's harder to get them all individually.
    -- Fairly straightforward...
    if speech == "yes" then
        if actor.alignment > 349 then
            actor.name:start_quest("sunfire_rescue")
            self:emote("smiles brightly at " .. tostring(actor.name) .. " and looks hopeful.")
            self:say("Thank you! Please return to me with the items and I will be most grateful.")
            self:emote("pauses a moment.")
            self:say("Oh, and do not bother with the cursed items.  I can tell the difference.")
            self.room:send("The prisoner looks apprehensive.")
            self:whisper(actor.name, "You should leave here before the guards come!")
            self:emote("relaxes back into a position of pain, though he smiles at you.")
        end
    end
    if speech == "no" then
        self:emote("frowns at " .. tostring(actor.name) .. " stormily.")
        self:say("Then waste my time no more, and begone!")
        actor.name:move("north")
        -- Oooh, he gets really mad here.
    end
end