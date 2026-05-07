-- Trigger: Disc_Toss
-- Zone: 22, ID: 61
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #2261

-- Converted from DG Script #2261: Disc_Toss
-- Original: OBJECT trigger, flags: GET, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end
-- TODO(parity): empty body — original DG #2261 "Disc_Toss" body was lost in conversion.
-- Likely a quest clue trigger similar to siblings 50-60 (object COMMAND-style flavour
-- text revealing a riddle line). Needs reimplementation from DG source.
-- (placeholder trigger)