-- Trigger: half-elf_encoded_trigger
-- Zone: 238, ID: 41
-- Type: OBJECT, Flags: COMMAND
--
-- 2% chance per "look pentagram/star/inscribed/circle" command. If the player
-- has the comprehend-languages spell active, reveal the half-elf clue;
-- otherwise just print a placeholder line.
--
-- TODO(parity): the original DG checked the comprehend-languages effect via
-- %actor.has_effect(comprehend lang)%. The Effect table registered in
-- script_engine.cpp does not currently expose a ComprehendLang entry, and the
-- effect catalog in the database doesn't yet model individual buff names.
-- Using actor:has_effect_named("ComprehendLang") as a best-effort string
-- match -- update once the canonical effect name is confirmed.

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: pentagram star inscribed circle
if not (cmd == "pentagram" or cmd == "star" or cmd == "inscribed" or cmd == "circle") then
    return true  -- Not our command
end
if actor:has_effect_named("ComprehendLang") then
    actor:send("The circle around this pentagram is not a line, but rather tiny script. It")
    actor:send("reads: \"The one who wore purple stood next to the half-elf\".")
else
    actor:send("this is a test message for now")
end
