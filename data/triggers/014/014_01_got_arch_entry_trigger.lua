-- Trigger: GoT_Arch_Entry_Trigger
-- Zone: 14, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: NEEDS-WORK (door state mutation API not yet exposed)
--
-- Original DG Script: #1401
--
-- Intent: Mirror of trigger 14/0 but firing from inside the Caelia
-- caravan-route side (room 23/310). When a player wearing the Eyes of
-- Truth (item 14/6) speaks "aderci", the same archway toggle runs.
-- Body is identical to 14/0; only the room the script is attached to
-- (and therefore which side broadcasts which flavor line) differs.

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
    -- 14/0 with name "entry arch" / description "A large archway
    -- opens up to one of Caelia's southern caravan routes.", then
    -- mirrored those changes on the north exit of room 23/310
    -- (description: "A large archway leads into an inviting, stone
    -- structure.").
    -- TODO: cross-room flavor (originally posted to room 14/0):
    -- "The barrier protecting the entry archway flares momentarily as it powers down."
    self.room:send("The northern archway's protective barrier flares momentarily as it powers down.")
else
    -- Door open, lets close and lock it!
    globals.got_hall_open = 0
    -- TODO: door state API not yet exposed in mud-script. Original
    -- script closed, locked, and pickproofed the south exit of room
    -- 14/0 with description "A large archway is protected by a
    -- near-ethereal, humming, force field.", then mirrored those
    -- changes on the north exit of room 23/310 (description: "The
    -- archway leading into the structure is protected by a force field.").
    -- TODO: cross-room flavor (originally posted to room 14/0):
    -- "The barrier protecting the entry archway flares momentarily as it powers up."
    self.room:send("The northern archway's protective barrier flares momentarily as it powers up.")
end
