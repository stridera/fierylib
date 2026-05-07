-- Trigger: Pawn Shop (Nordus)
-- Zone: 510, ID: 0
-- Type: WORLD, Flags: SPEECH
--
-- Original DG Script: #51000
-- Speech keywords: "floor phrase is"
-- Validates the spoken phrase against the random `chosen` index set by
-- 510_02 (set_encrytped_phrase) and, on match, briefly opens the down
-- exit from room 51030 to room 51075.

-- Speech keywords: "floor phrase is"
local speech_lower = string.lower(speech or "")
if not string.find(speech_lower, "floor phrase is") then
    return true
end

-- Switch on the global `chosen` index (set when the player entered the
-- room — see 510_02). Each case demands a specific phrase.
local flagit = 0
if chosen == 1 and speech_lower == "floor phrase is open sesame" then
    flagit = 1
elseif chosen == 2 and speech_lower == "floor phrase is eingang bitte" then
    flagit = 1
elseif chosen == 3 and speech_lower == "floor phrase is traverser dedans" then
    flagit = 1
elseif chosen == 4 and speech_lower == "floor phrase is let me in dorkus" then
    flagit = 1
end

if flagit == 1 then
    -- TODO(parity): Lua runtime does not yet expose dynamic exit/door
    -- mutation (no `room:exit(dir):set_state{...}` / `:set_destination`).
    -- The intent is to temporarily reveal the down exit from room
    -- (510, 30) to (510, 75) for ~7 seconds, then reseal it. Restore
    -- when the door API lands.
    self.room:send("The ground begins to rumble and the dirt begins to part.")
    wait(7)
    self.room:send("The ground again begins to tremble as the passageway dissolves.")
    wait(5)
    self.room:send("The floor returns to normal without a trace of the secret it holds.")
end
