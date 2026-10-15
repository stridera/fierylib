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

-- Speech phrase: All Hail Uklor (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]all hail uklor[%s%p]") then
    return true  -- Not the phrase
end

if actor.is_player then
    self.room:send("</><b:black>The ancient </><magenta>obelisk</><b:black> hums with pleasure.</>")
    self.room:send("A gust of </><white></>divine</><b:yellow> energy</> sweeps through the room, leaving a loaf of </><yellow>bread</> in its wake.")
    self.room:spawn_object(147, 11)
end
