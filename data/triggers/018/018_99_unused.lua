-- Trigger: unused
-- Zone: 18, ID: 99
-- Type: WORLD, Flags: COMMAND, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1899

-- Converted from DG Script #1899: unused
-- Original: WORLD trigger, flags: COMMAND, SPEECH, probability: 100%

-- TODO(parity): legacy trigger matched on either a `reset_the_quest` command
-- OR speech containing "reset_the_quest". Body is a placeholder — debug hook
-- that was never finished. Safe to gate behind both checks since either
-- channel can fire WORLD/COMMAND+SPEECH triggers.
local matched_cmd = cmd == "reset_the_quest"
local matched_speech = speech and string.find(string.lower(speech), "reset_the_quest")
if not (matched_cmd or matched_speech) then
    return true
end
-- (placeholder trigger — no body)