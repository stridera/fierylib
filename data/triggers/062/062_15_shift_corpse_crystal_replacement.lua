-- Trigger: shift_corpse_crystal_replacement
-- Zone: 62, ID: 15
-- Type: MOB, Flags: SPEECH
--
-- Lets a shift_corpse questor request a replacement glowing black crystal
-- (62, 28) if they lost the original. Keyword sentence: "I need a new crystal".
--
-- Original DG Script: #6215

-- TODO(parity): Original DG had probability=0, which makes this script
-- entirely unreachable. The synthetic `percent_chance(0)` gate has been
-- removed so the keyword filter can fire. Verify whether the original author
-- intentionally disabled the script or it was an authoring mistake.

-- Speech phrase: new crystal (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]new crystal[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
if actor:get_quest_stage("shift_corpse") > 0 and actor:get_quest_stage("shift_corpse") > 0 then
    self:say("I can assist.")
    wait(1)
    self:emote("opens a pitch black box.")
    wait(0.4)
    self:emote("takes a glowing black crystal from the box.")
    wait(1)
    self:say("Take this.")
    self.room:spawn_object(62, 28)
    self:command("give glowing-black-crystal " .. tostring(actor))
    wait(1)
    self:say("Be more careful this time.")
end