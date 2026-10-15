-- Trigger: instant reboot
-- Zone: 0, ID: 25
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #25
-- Diagnostic: saying "reboot now" reports the actor count of two well-known
-- rooms. Useful for quick population checks.
-- TODO(parity): original DG probability was 0% (effectively disabled). If this
--               diagnostic should remain disabled, remove it from the room's
--               script list rather than gating here.

-- Speech phrase: reboot now (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]reboot now[%s%p]") then
    return true  -- Not the phrase
end

self.room:send(tostring(get_room(30, 54).actor_count))
self.room:send(tostring(get_room(510, 36).actor_count))
