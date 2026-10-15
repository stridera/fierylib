-- Trigger: serin-templace
-- Zone: 237, ID: 23
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #23723

-- Converted from DG Script #23723: serin-templace
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"no", "nope", "sorry"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor.is_player and actor.alignment > 349 then
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
        actor:start_quest("sunfire_rescue")
    elseif actor:get_quest_stage("sunfire_rescue") == 1 then
        self:emote("frowns at " .. tostring(actor.name) .. " stormily.")
        self:say("Then waste my time no more, and begone!")
        actor:move("north")
        -- Oooh, he gets really mad here.
        -- TODO(parity): original DG script erased "sunfire_quest" (likely typo for "sunfire_rescue").
        -- Preserving original quest name to avoid silently abandoning the active quest.
        actor:erase_quest("sunfire_quest")
    end
end