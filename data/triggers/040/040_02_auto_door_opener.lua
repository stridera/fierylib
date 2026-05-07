-- Trigger: Auto door opener
-- Zone: 40, ID: 2
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4002
-- Reveals the hidden up exit in room (40, 19) for 10 pulses when a
-- passphrase is spoken. Original DG probability is 0% (preserved);
-- effectively disabled until the script is re-enabled.
-- TODO: original keyword list "darkness hear my call unto you" looks
-- like a single phrase; the converter expanded it into an `or` chain
-- that matches almost any English speech. Re-enabling the script
-- should likely require the full phrase instead.

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: darkness hear my call unto you
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "darkness")
        or string.find(speech_lower, "hear")
        or string.find(speech_lower, "my")
        or string.find(speech_lower, "call")
        or string.find(speech_lower, "unto")
        or string.find(speech_lower, "you")) then
    return true  -- No matching keywords
end

get_room(40, 19):exit("up"):set_state({hidden = false})
self.room:send("The southern wall crumbles and falls as darkness flees from behind it.")
self.room:send("Unknowing steps are revealed ascending.")
wait(10)
get_room(40, 19):exit("up"):set_state({hidden = true})
