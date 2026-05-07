-- Trigger: south-blessing
-- Zone: 23, ID: 3
-- Type: WORLD, Flags: SPEECH
-- Status: GATED_OFF
--
-- Original DG Script: #2303
-- The legacy DG trigger had a 0% probability and an `or`-joined keyword
-- filter ("i", "pray", "for", "a", ...) that would match almost any
-- utterance. The 0% gate kept it dormant in the legacy world.
--
-- TODO(parity): Rewrite the keyword filter as a phrase match (or use
-- string.find on the full incantation) and remove the 0% gate to actually
-- ship the south monolith blessing. As-is the trigger never fires.

-- Disabled by legacy 0% probability (preserves shipped behaviour).
if not percent_chance(0) then
    return true
end

-- Speech keywords: I pray for a blessing from mother earth, creator of life and bringer of death
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "pray") or string.find(string.lower(speech), "for") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "blessing") or string.find(string.lower(speech), "from") or string.find(string.lower(speech), "mother") or string.find(string.lower(speech), "earth,") or string.find(string.lower(speech), "creator") or string.find(string.lower(speech), "of") or string.find(string.lower(speech), "life") or string.find(string.lower(speech), "and") or string.find(string.lower(speech), "bringer") or string.find(string.lower(speech), "of") or string.find(string.lower(speech), "death")) then
    return true  -- No matching keywords
end
self.room:send("The &9<blue>stone monoliths</> begin to <b:cyan>glow</> with power.")
wait(4)
self.room:spawn_object(23, 31)
self.room:send("<b:white>The power seems to coalesce into a shining ball.</>")
wait(20)
self.room:purge()
self.room:send("The <b:white>shining ball</> dissapates back into nothingness.")
self.room:send("The &9<blue>stones</> stop glowing.")