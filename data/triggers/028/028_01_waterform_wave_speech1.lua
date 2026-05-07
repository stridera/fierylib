-- Trigger: waterform_wave_speech1
-- Zone: 28, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: REVIEWED (player guard added; speech match nil-safe)
--
-- Original DG Script: #2801
-- The Great Wave's reply to "yes / okay / how / protection" -- starts the
-- waterform quest for a high-level Cryomancer, or nudges the player along
-- depending on stage.
-- Note: original DG probability was 1% (very flaky). We honor it as-is so
-- behavior matches the legacy game; player can re-say to retry.

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: yes / protection / how / okay
local speech_lower = string.lower(speech or "")
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "protection")
        or string.find(speech_lower, "how") or string.find(speech_lower, "okay")) then
    return true
end
wait(2)
local stage = actor:get_quest_stage("waterform")
if stage == 0 and actor.is_player and actor.class
        and string.find(actor.class, "Cryomancer") and actor.level > 72 then
    actor:start_quest("waterform")
    self.room:send(tostring(self.name) .. " says, 'I can teach you to transform you into a raging torrent,")
    self.room:send("</>giving you the strength of the water itself!  All you need is a single piece of")
    self.room:send("</>armor made from water to wrap about you.'")
    -- 
    -- THIS. IS. A. LIE.  Yes, the quest master, a talking wave, gets the material components of its own spell wrong.
    -- 
    wait(4)
    self:say("Bring it to me and I will teach you the transformation!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you forget, you can ask me for a reminder of your")
    self.room:send("</><b:white>[progress]</>.'")
elseif stage == 1 then
    self:say("Then please give it to me.")
elseif stage == 2 or stage == 3 then
    self:say("Then please give it to me.")
elseif stage == 4 then
    self:say("Splendid!  Please, keep at it!")
elseif stage == 5 then
    self:say("Splendid!  Give me the bone cup if you're done.")
elseif stage == 6 then
    self.room:send(tostring(self.name) .. " says, 'If you need, you may ask for a reminder of your")
    self.room:send("</><b:white>[progress]</>.'")
end