-- Trigger: blob-to-pawnbroker
-- Zone: 30, ID: 40
-- Type: MOB, Flags: RANDOM, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3040

-- Converted from DG Script #3040: blob-to-pawnbroker
-- Original: MOB trigger, flags: RANDOM, SPEECH, num_arg: 1 (word list and random chance)

-- RANDOM + SPEECH trigger (num_arg 1): a spoken word list when someone speaks (event is SPEECH,
-- speech is the text), a 1% roll on the random pulse (event is RANDOM).
if event == "SPEECH" then
    -- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
    local speech_padded = " " .. string.lower(speech) .. " "
    local speech_hit = false
    for _, w in ipairs({"drop", "off", "the", "junk"}) do
        if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
            speech_hit = true
            break
        end
    end
    if not speech_hit then
        return true  -- None of the listed words
    end
elseif not percent_chance(1) then
    return true
end
self:teleport(get_room(61, 72))
self:destroy_item("all.key")
self.room:find_actor("anduin_pawnbroker"):teleport(get_room(61, 72))
self:command("remove all")
self:command("drop all")
self.room:find_actor("pawnbroker"):command("get all")
self.room:find_actor("anduin_pawnbroker"):teleport(get_room(60, 34))
local randmielrm = random(1, 18)
self:teleport(get_room(30, 51 + randmielrm))