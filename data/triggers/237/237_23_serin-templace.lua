-- Trigger: serin-templace
-- Zone: 237, ID: 23
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #23723

-- Converted from DG Script #23723: serin-templace
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: no nope sorry
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "no") or string.find(string.lower(speech), "nope") or string.find(string.lower(speech), "sorry")) then
    return true  -- No matching keywords
end
wait(2)
if actor.id == -1 and actor.alignment > 349 then
    if actor:get_quest_stage("sunfire_rescue") == 0 then
        -- Responding to trigger 23722 in the prisoner quest.
        -- This leads directly to the actual quest trigger.
        self:emote("looks grief-stricken.")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Well, perhaps you can still help me.  My peoples'")
        self.room:send("</>treasures must be in the hands of Templace's conquerors.  If you could return")
        self.room:send("</>to me a <b:green>cloak</>, <b:green>boots</> and a <b:green>ring of the elves</>...'")
        wait(1)
        self:emote("smiles fiercely.")
        wait(1)
        self:say("I could finally escape.  Will you do this for me?")
        actor.name:start_quest("sunfire_rescue")
    elseif actor:get_quest_stage("sunfire_rescue") == 1 then
        self:emote("frowns at " .. tostring(actor.name) .. " stormily.")
        self:say("Then waste my time no more, and begone!")
        actor.name:move("north")
        -- Oooh, he gets really mad here.
        actor.name:erase_quest("sunfire_quest")
    end
end