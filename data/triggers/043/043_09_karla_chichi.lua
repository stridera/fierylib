-- Trigger: karla_chichi
-- Zone: 43, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4309

-- Converted from DG Script #4309: karla_chichi
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: don't you think so? (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]don%'t you think so[%s%p]") then
    return true  -- Not the phrase
end
-- TODO(parity): original DG checked for chichi (mob 4301) in the room; rewrite
-- once the runtime exposes a way to look up actors by composite (zone, id) in a room.
if self.room:find_actor("chichi") then
    self:emote("gets up in a player's face.")
    self:say("Oh no you di'in' Chichi!")
    wait(0.5)
    self:say("You best step off!")
    self:emote("struts around the room, waiving her finger.")
end