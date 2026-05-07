-- Trigger: heavens_gate_key_replacement
-- Zone: 133, ID: 33
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13333
--
-- Replacement Key of Heaven dispenser. While at quest stage 3, an actor
-- can speak "Grant me a new key" to ask the starlight for a fresh copy
-- of the Key of Heaven (133, 51) if theirs has been lost. If they still
-- carry the original we refuse the replacement.
--
-- TODO(parity): the legacy DG script had probability 0%, which the
-- converter translated into a `percent_chance(0)` gate that would block
-- every fire. We've removed the synthetic gate; the keyword filter is
-- now the only gate. Confirm legacy intent.

local required = { "grant", "me", "a", "new", "key" }
local speech_lower = string.lower(speech)
for _, word in ipairs(required) do
    if not string.find(speech_lower, word) then
        return true
    end
end

if actor:get_quest_stage("heavens_gate") ~= 3 then
    return true
end

wait(2)
if actor:has_item(133, 51) then
    actor:send("<b:cyan>You already possess a Key of Heaven.</>")
    return true
end

self.room:send("<b:white>The stars coalesce into a shining key!</>")
self.room:spawn_object(133, 51)
self:command("give key-heaven " .. tostring(actor.name))
return true
