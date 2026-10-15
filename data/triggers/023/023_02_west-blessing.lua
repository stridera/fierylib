-- Trigger: west-blessing
-- Zone: 23, ID: 2
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2302
-- Legacy DG speech trigger with num_arg 0: it fires when the speech contains
-- the full incantation. The converter read the 0 as a 0% chance (so it never
-- fired) and split the phrase into an `or` chain of single words; both are now
-- one phrase test, so the west monolith blessing works again.

-- Speech phrase: i pray for a blessing from mother earth, creator of life and bringer of death (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]i pray for a blessing from mother earth%, creator of life and bringer of death[%s%p]") then
    return true  -- Not the phrase
end
self.room:send("The <b:black>stone monoliths</> begin to <b:cyan>glow</> with power.")
wait(4)
self.room:spawn_object(23, 33)
self.room:send("<green>The power seems to coalesce into a shining ball.</>")
wait(20)
self.room:purge()
self.room:send("The <green>shining ball</> dissapates back into nothingness.")
self.room:send("The <b:black>stones</> stop glowing.")