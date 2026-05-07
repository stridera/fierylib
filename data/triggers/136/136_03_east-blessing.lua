-- Trigger: east-blessing
-- Zone: 136, ID: 3
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13603

-- Converted from DG Script #13603: east-blessing
-- Original: ROOM trigger, flags: SPEECH

-- Speech keyword: the entire phrase below must appear in what was said.
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "i pray for a blessing from mother earth, creator of life and bringer of death", 1, true) then
    return true  -- No matching phrase
end
self.room:send("The &9<blue>stone monoliths</> begin to <b:cyan>glow</> with power.")
wait(4)
self.room:spawn_object(23, 30)
self.room:send("The <b:cyan>power</> seems to coalesce into a <b:white>shining ball</>.")
wait(20)
self.room:purge()
self.room:send("The <b:white>shining ball</> dissapates back into nothingness.")
self.room:send("The &9<blue>stones</> stop glowing.")