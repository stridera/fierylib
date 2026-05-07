-- Trigger: GoT_Arch_Exit_Trigger
-- Zone: 14, ID: 0
-- Type: WORLD, Flags: SPEECH
-- Status: NEEDS-WORK (door state mutation API not yet exposed)
--
-- Original DG Script: #1400
--
-- Intent: When a player wearing the Eyes of Truth (item 14/6) speaks the
-- pass-phrase "aderci" inside the Guards-of-Truth hall, toggle the south
-- archway between locked-closed and unlocked-open. The far side
-- archway in zone 23 (room 23/310) is kept in sync. Both rooms get a
-- flavor message on toggle.

-- Speech keywords: aderci
if not string.find(string.lower(speech), "aderci") then
    return true  -- No matching keywords
end
wait(1)
if not actor:has_equipped(14, 6) then
    -- No Eyes of Truth, no exit!
    return true
end

-- Check the persistent door-open flag. If closed/locked, open it; if
-- open, close and lock it back up.
if globals.got_hall_open ~= 1 then
    -- Door closed and locked, lets open it!
    globals.got_hall_open = 1
    -- TODO: door state API not yet exposed in mud-script. Original
    -- script unlocked, opened, and unhid the south exit of room
    -- 14/0, set its name to "entry arch" and rewrote its description
    -- to "A large archway opens up to one of Caelia's southern caravan
    -- routes.", then mirrored those changes on the north exit of
    -- room 23/310 (description: "A large archway leads into an
    -- inviting, stone structure.").
    self.room:send("The barrier protecting the entry archway flares momentarily as it powers down.")
    -- TODO: cross-room flavor (originally posted to room 23/310):
    -- "The northern archway's protective barrier flares momentarily as it powers down."
else
    -- Door open, lets close and lock it!
    globals.got_hall_open = 0
    -- TODO: door state API not yet exposed in mud-script. Original
    -- script closed, locked, and pickproofed the south exit of room
    -- 14/0 with description "A large archway is protected by a
    -- near-ethereal, humming, force field.", then mirrored those
    -- changes on the north exit of room 23/310 (description: "The
    -- archway leading into the structure is protected by a force field.").
    self.room:send("The barrier protecting the entry archway flares momentarily as it powers up.")
    -- TODO: cross-room flavor (originally posted to room 23/310):
    -- "The northern archway's protective barrier flares momentarily as it powers up."
end
