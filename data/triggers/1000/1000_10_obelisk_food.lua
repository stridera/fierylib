-- Trigger: Obelisk (Food)
-- Zone: 0, ID: 10
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10
-- Speech "All Hail Uklor" by a player makes the obelisk hum and produces bread.
-- TODO(parity): original DG probability was 0% (effectively disabled). If this
--               trigger should remain disabled, remove from the room's script
--               list rather than gating here.

-- Speech keywords: all hail uklor (all three required)
local s = string.lower(speech)
if not (string.find(s, "all") and string.find(s, "hail") and string.find(s, "uklor")) then
    return true
end

if actor.is_player then
    self.room:send("</>&9<blue>The ancient </><magenta>obelisk</>&9<blue> hums with pleasure.</>")
    self.room:send("A gust of </><white></>divine</><b:yellow> energy</> sweeps through the room, leaving a loaf of </><yellow>bread</> in its wake.")
    self.room:spawn_object(147, 11)
end
