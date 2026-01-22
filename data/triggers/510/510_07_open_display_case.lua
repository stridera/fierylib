-- Trigger: open_display_case
-- Zone: 510, ID: 7
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51007

-- Converted from DG Script #51007: open_display_case
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: amehs
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "amehs")) then
    return true  -- No matching keywords
end
if got_book == 1 then
    actor:send("You marvel at the resonant tones of your voice, perhaps you should be an actor.")
else
    self.room:send("The display case folds and collapses to the floor.")
    world.destroy(self.room:find_actor("display-case"))
    self.room:spawn_object(510, 22)
    -- load the display case in the holding area to avoid a second oneloading
    get_room(510, 99):at(function()
        self.room:spawn_object(510, 21)
    end)
    local got_book = 1
    globals.got_book = globals.got_book or true
end