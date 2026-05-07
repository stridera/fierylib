-- Trigger: exit_room_58196_part_2
-- Zone: 580, ID: 101
-- Type: WORLD, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Companion to 580_100. When someone in room 58196 speaks Kannon's
-- name (kannon / kwan yin), the goddess teleports the whole room to
-- 580/194 and forces a look so they see the new room.
--
-- TODO: after `teleport_all` self.room is the *old* room; the
-- subsequent `find_actor("all")` lookup runs in the wrong room. Capture
-- the destination first, then iterate destination actors and force look
-- on each, e.g.:
--   local dest = get_room(580, 194)
--   self.room:teleport_all(dest)
--   for _, a in ipairs(dest.actors) do a:command("look") end
-- TODO: keyword "yin" alone is loose -- matches any word containing
-- yin. Tighten to "kwan yin" / "kannon".

-- Speech keywords: kannon / kwan / yin
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "kannon") or string.find(speech_lower, "kwan") or string.find(speech_lower, "yin")) then
    return true  -- No matching keywords
end
self.room:send("You can hear a faint voice say, 'I wish I could do more to help you...'")
self.room:send("Your vision blurs for a moment and there is a noise as of a rushing wind.")
self.room:teleport_all(get_room(580, 194))
get_room(580, 194):at(function()
    self.room:find_actor("all"):command("look")
end)