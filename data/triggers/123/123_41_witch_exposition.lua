-- Trigger: witch_exposition
-- Zone: 123, ID: 41
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #12341

-- Converted from DG Script #12341: witch_exposition
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: who continue
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "who") or string.find(string.lower(speech), "continue")) then
    return true  -- No matching keywords
end
if (string.find(speech, "who are you") or string.find(speech, "continue")) and actor.is_player then
    -- TODO(parity): the converter flattened a `switch on self.id` block
    -- into three identical-shape branches (Ickle, Mielikki, and Anduin
    -- variants). The original wanted per-town flavor lines keyed by the
    -- speaking witch's id; those were lost. Until restored, we roll a
    -- single d4 and pick a generic flavor line.
    local roll = random(1, 4)
    if roll == 1 then
        self:say("No one special, merely a Sister in sacred trust.")
    elseif roll == 2 then
        self:say("Just a peasant from Ickle.")
    elseif roll == 3 then
        self.room:send(tostring(self.name) .. " says, 'That is an excellent question...")
        self.room:send("</>Who are any of us?'")
        self:command("ponder")
    elseif roll == 4 then
        -- Intentionally silent (matches the empty branch in the original).
    else
        self:say("I'm quite busy right now, that's who I am.")
    end
end