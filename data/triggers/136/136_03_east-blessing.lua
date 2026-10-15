-- Trigger: east-blessing
-- Zone: 136, ID: 3
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13603

-- Converted from DG Script #13603: east-blessing
-- Original: ROOM trigger, flags: SPEECH

-- Speech phrase: i pray for a blessing from mother earth, creator of life and bringer of death (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]i pray for a blessing from mother earth%, creator of life and bringer of death[%s%p]") then
    return true  -- Not the phrase
end
self.room:send("The <b:black>stone monoliths</> begin to <b:cyan>glow</> with power.")
wait(4)
self.room:spawn_object(23, 30)
self.room:send("The <b:cyan>power</> seems to coalesce into a <b:white>shining ball</>.")
wait(20)
self.room:purge()
self.room:send("The <b:white>shining ball</> dissapates back into nothingness.")
self.room:send("The <b:black>stones</> stop glowing.")