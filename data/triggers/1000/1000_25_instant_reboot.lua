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

-- Speech keywords: "reboot now" (both required)
local s = string.lower(speech)
if not (string.find(s, "reboot") and string.find(s, "now")) then
    return true
end

self.room:send(tostring(get_room(30, 54).actor_count))
self.room:send(tostring(get_room(510, 36).actor_count))
