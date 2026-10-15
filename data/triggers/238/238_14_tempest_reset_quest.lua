-- Trigger: tempest_reset_quest
-- Zone: 238, ID: 14
-- Type: WORLD, Flags: SPEECH
--
-- Run-from-other-trigger entry point (mage_receive / mage_speak3 wrong-answer
-- branch fires this in the Tempest's room). Removes the held blue-flame and
-- clears the global flag so a fresh tempest_start_quest can re-equip it.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"secretcommandtoresetquest"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:find_actor("tempest-manifest"):destroy_item("blue-flame")
globals.has_flame = false
