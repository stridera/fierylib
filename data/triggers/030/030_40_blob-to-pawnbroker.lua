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
-- Legacy: mgoto 6172, junk the keys, mteleport anduin_pawnbroker (60:16, the pawnbroker, wherever
-- he is) to 6172, drop everything for him to collect, send him back to 6034, then mgoto a random
-- room 3052..3069. Every piece is looked up before the first move, so a missing mob or room
-- leaves the blob where it is instead of stranding it in the back room.
local broker = world.find_mobile(60, 16)
local back_room = get_room(61, 72)
local shop = get_room(60, 34)
local dest = get_room(30, 51 + random(1, 18))
if not broker or not back_room or not shop or not dest then
    return true
end
local ok, err = pcall(function()
    self:teleport(back_room)
    self:destroy_item("all.key")
    broker:teleport(back_room)
    self:command("remove all")
    self:command("drop all")
    broker:command("get all")
end)
-- Whatever happened above, both of them go home.
broker:teleport(shop)
self:teleport(dest)
if not ok then
    error(err, 0)
end
