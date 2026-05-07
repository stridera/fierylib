-- Trigger: dargentan_chest_load
-- Zone: 238, ID: 20
-- Type: WORLD, Flags: SPEECH
--
-- Run-from-other-trigger entry point fired by 238_19_dargentan_drop_treasure
-- (Dargentan's death). Spawns the treasure object (238:48) on the floor and
-- prints the discovery line. The original DG declared probability 0% and used
-- a secret-keyword speech filter to keep players from invoking it directly;
-- we keep the keyword filter as defense-in-depth.

-- Speech keywords: donteverletmecatchyouusingthisspeechtrigger
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "donteverletmecatchyouusingthisspeechtrigger") then
    return true  -- No matching keywords
end
self.room:spawn_object(238, 48)
self.room:send("As the dragon falls, you notice something that wasn't there before...")
