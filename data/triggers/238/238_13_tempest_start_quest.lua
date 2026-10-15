-- Trigger: tempest_start_quest
-- Zone: 238, ID: 13
-- Type: WORLD, Flags: SPEECH
--
-- Run-from-other-trigger entry point (mage_speak2 fires this in the Tempest's
-- room via run_room_trigger). Spawns the quest blue-flame on the Tempest and
-- has it hold the flame, but only once per zone reset.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"secretcommandtostartquest"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if not globals.has_flame then
    local tempest = self.room:find_actor("tempest-manifest")
    tempest:spawn_object(238, 22)
    tempest:command("hold blue-flame")
    globals.has_flame = true
end
