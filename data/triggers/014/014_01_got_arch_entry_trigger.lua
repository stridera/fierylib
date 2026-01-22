-- Trigger: GoT_Arch_Entry_Trigger
-- Zone: 14, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1401

-- Converted from DG Script #1401: GoT_Arch_Entry_Trigger
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: aderci
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "aderci")) then
    return true  -- No matching keywords
end
wait(1)
if actor:has_equipped("1406") then
    -- Check to see if the door field is open/unlocked, if not lets
    -- set a variable and unlock/open it.  If so, close/lock it
    -- and unset the variable.
    if got_hall_open ~= 1 then
        -- Door closed and locked, lets open it!
        local got_hall_open = 1
        globals.got_hall_open = globals.got_hall_open or true
        doors.set_flags(get_room(14, 0), "south", "acd")
        doors.set_state(get_room(14, 0), "south", {action = "room"})
        doors.set_name(get_room(14, 0), "south", "entry arch")
        doors.set_description(get_room(14, 0), "south", "A large archway opens up to one of Caelia's southern caravan routes.")
        get_room(14, 0):at(function()
            self.room:send("The barrier protecting the entry archway flares momentarily as it powers down.")
        end)
        -- create the other side and link.
        doors.set_flags(get_room(26, 10), "north", "acd")
        doors.set_state(get_room(26, 10), "north", {action = "room"})
        doors.set_description(get_room(26, 10), "north", "A large archway leads into an inviting, stone structure.")
        self.room:send("The northern archway's protective barrier flares momentarily as it powers down.")
    else
        -- Door open, lets close and lock it!
        local got_hall_open = 0
        globals.got_hall_open = globals.got_hall_open or true
        doors.set_flags(get_room(14, 0), "south", "abcd")
        doors.set_state(get_room(14, 0), "south", {action = "room"})
        doors.set_description(get_room(14, 0), "south", "A large archway is protected by a near-ethereal, humming, force field.")
        get_room(14, 0):at(function()
            self.room:send("The barrier protecting the entry archway flares momentarily as it powers up.")
        end)
        -- create the other side and link
        doors.set_flags(get_room(26, 10), "north", "abcd")
        doors.set_state(get_room(26, 10), "north", {action = "room"})
        doors.set_name(get_room(26, 10), "north", "entry arch")
        doors.set_description(get_room(26, 10), "north", "The archway leading into the structure is protected by a force field.")
        self.room:send("The northern archway's protective barrier flares momentarily as it powers up.")
    end
else
    -- No Eyes of Truth, no exit!
end