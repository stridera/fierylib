-- Trigger: test
-- Zone: 188, ID: 83
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW (debug-only stub; original DG used eval, not portable)
--
-- Original DG Script: #18883
-- Converted from DG Script #18883: test
-- Original: MOB trigger, flags: SPEECH, probability: 1%
--
-- TODO(parity): the legacy DG `eval %speech%` evaluated the spoken text as
-- DG-script. There is no Lua equivalent and shipping eval-of-player-input
-- would be a security hole. Either delete this trigger or replace with a
-- specific debug command list.

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: eval
if not (string.find(string.lower(speech), "eval")) then
    return true  -- No matching keywords
end
self.room:send("(debug) speech received: " .. tostring(speech))