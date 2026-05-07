-- Trigger: room_monkquest_entry
-- Zone: 51, ID: 14
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #5114

-- Converted from DG Script #5114: room_monkquest_entry
-- Original: WORLD trigger, flags: COMMAND, probability: 0%
--
-- "bow priest" -- the monk-quest entry priest opens the stone door east
-- to 580/25 (Arre's chamber) when the player bows to him.
--
-- Note: legacy DG header listed probability 0%, but command triggers in
-- DG fired on every keyword match regardless of header probability --
-- the converter's percent_chance(0) gate has been removed.
--
-- TODO(parity): the original DG used `case b / case bo: return 0` to
-- block partial-form `b` / `bo` of `bow`. The converter generated
-- `_return_value = true` (allow) for those partial cases and the outer
-- exact-match filter (`cmd == "bow"`) makes the inner branch dead code
-- anyway. Revisit once we know how the runtime delivers the abbreviated
-- vs full command name.
-- TODO: original DG also issued `wdoor 58025 east key -1` to clear the
-- door key. doors.set_key isn't exposed yet; carrying the gap forward.

-- Command filter: bow priest
if not (cmd == "bow" or cmd == "priest") then
    return true  -- Not our command
end
local priest_name = mobiles.template(51, 31).name
actor:command("bow")
self.room:find_actor("monk_quest_priest"):emote("smiles broadly, pressing in a crack in the wall.")
local door_east = get_room(580, 25):exit("east")
door_east:set_state({
    has_door = true,
    hidden = false,
    name = "heavy stone door",
    description = "A heavy slab of stone sits in your way.",
})
wait(3)
self.room:send(priest_name .. " presses a little harder, fully opening the stone door.")
self.room:send_except(actor, priest_name .. " points to the east and nudges " .. actor.name .. " forward.")
actor:send(priest_name .. " points to the east and nudges you forward.")
return true
