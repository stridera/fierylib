-- Trigger: witch_exposition
-- Zone: 123, ID: 41
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <witch_exposition>:9: ')' expected near 'are'
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
    -- switch on self.id
    -- switch on random(1, 4)
    if random(1, 4) == 1 then
        self:say("No one special, merely a Sister in sacred trust.")
    elseif random(1, 4) == 2 then
        self:say("Just a peasant from Ickle.")
    elseif random(1, 4) == 3 then
        self.room:send(tostring(self.name) .. " says, 'That is an excellent question...")
        self.room:send("</>Who are any of us?'")
        self:command("ponder")
    elseif random(1, 4) == 4 then
    else
        self:say("I'm quite busy right now, that's who I am.")
    end
    return _return_value
    -- The converter flattened a `switch on self.id` block into
    -- three identical-shape branches — Ickle, Mielikki, and
    -- Anduin variants — but they were left as dead code after
    -- the return above. TODO(parity): split by self.id when
    -- restoring the per-town flavor lines.
end