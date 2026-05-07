-- Trigger: lantern shows the path
-- Zone: 51, ID: 19
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #5119

-- Converted from DG Script #5119: lantern shows the path
-- Original: WORLD trigger, flags: COMMAND, probability: 0%
--
-- "look lantern" (any abbreviation of `lantern`) -- the stone lantern
-- emits a glow that briefly reveals a hidden west exit from 580/1 to
-- 580/17, then fades and clears the exit destination again.
--
-- Note: legacy DG header listed probability 0%, but command triggers in
-- DG fired on every keyword match regardless of header probability --
-- the converter's percent_chance(0) gate has been removed.

-- Command filter: look <lantern abbreviation>
if cmd ~= "look" then
    return true  -- Not our command
end
local arg_lower = string.lower(arg or "")
if not (#arg_lower > 0 and string.find("lantern", "^" .. arg_lower)) then
    return true  -- Not looking at the lantern
end
local entry = get_room(580, 1)
local west = entry:exit("west")
local hidden_break = get_room(580, 17)

actor:command("look lantern")
self.room:send_except(actor, actor.name .. " looks at the stone lantern.")
wait(2)
self.room:send("An eerie <b:yellow>glow</> begins emitting from the lantern...")
wait(5)
west:set_destination(hidden_break)
self.room:send("The light reveals a well-concealed break in the rocky hills to the west!")
wait(20)
self.room:send("The light begins to flicker and fade...")
wait(5)
west:set_destination(nil)
self.room:send("The passage west is obscured again as the glow of the lantern fades.")
return true