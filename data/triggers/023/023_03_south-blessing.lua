-- Trigger: south-blessing
-- Zone: 23, ID: 3
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2303
-- Legacy DG speech trigger with num_arg 0: it fires when the speech contains
-- the full incantation. The converter read the 0 as a 0% chance (so it never
-- fired) and split the phrase into an `or` chain of single words; both are now
-- one phrase test, so the south monolith blessing works again.

-- Speech phrase: I pray for a blessing from mother earth, creator of life and bringer of death (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i pray for a blessing from mother earth, creator of life and bringer of death", 1, true) then
    return true  -- Not the phrase
end
self.room:send("The <b:black>stone monoliths</> begin to <b:cyan>glow</> with power.")
wait(4)
self.room:spawn_object(23, 31)
self.room:send("<b:white>The power seems to coalesce into a shining ball.</>")
wait(20)
self.room:purge()
self.room:send("The <b:white>shining ball</> dissapates back into nothingness.")
self.room:send("The <b:black>stones</> stop glowing.")