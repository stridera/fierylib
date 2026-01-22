-- Trigger: north-blessing
-- Zone: 23, ID: 4
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2304

-- Converted from DG Script #2304: north-blessing
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
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
self.room:spawn_object(23, 32)
self.room:send("<green>The power seems to coalesce into a shining ball.</>")
wait(20)
self.room:purge()
self.room:send("The <green>shining ball</> dissapates back into nothingness.")
self.room:send("The &9<blue>stones</> stop glowing.")