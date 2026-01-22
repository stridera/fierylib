-- Trigger: half-elf_encoded_trigger
-- Zone: 238, ID: 41
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #23841

-- Converted from DG Script #23841: half-elf_encoded_trigger
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: pentagram star inscribed circle
if not (cmd == "pentagram" or cmd == "star" or cmd == "inscribed" or cmd == "circle") then
    return true  -- Not our command
end
if actor:has_effect(Effect.CompLang) then
    actor:send("The circle around this pentagram is not a line, but rather tiny script. It")
    actor:send("reads: \"The one who wore purple stood next to the half-elf\".")
else
    actor:send("this is a test message for now")
end