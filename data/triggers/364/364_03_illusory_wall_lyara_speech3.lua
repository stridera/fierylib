-- Trigger: illusory_wall_lyara_speech3
-- Zone: 364, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player accepts Lyara's offer ("yes" / "willing" / "sure" / "okay"). Starts
-- the illusory_wall quest and lists the three components needed for the
-- magic spectacles. Eligibility: Illusionist or Bard, level > 56, no prior
-- progress on the quest.
--
-- Original DG Script: #36403

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "willing", "sure", "okay"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if ((string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level > 56) and actor:get_quest_stage("illusory_wall") == 0 then
    actor:start_quest("illusory_wall")
    wait(0.2)
    self:say("Splendid!  Let's get you set up.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Replicating walls with tangible illusions is")
    self.room:send("</>difficult.  Typically I assign my students an extensive study of walls and")
    self.room:send("</>doors so they can formulate their own theories and aesthetics.'")
    wait(7)
    self.room:send(tostring(self.name) .. " says, 'But it will require a special study tool:")
    self.room:send("</><b:yellow>a pair of magic spectacles</>.'")
    wait(3)
    self:say("To construct you a pair, I'll need three things:")
    self.room:send("- <b:yellow>A pair of glasses</> or <b:yellow>small spectacles</> to look through")
    self.room:send("- <b:yellow>A prismatic leg spur</> to refract light properly")
    self.room:send("- <b:yellow>A small piece of petrified magic</> to enhance the magical sight of the lenses")
    wait(5)
    self:say("Bring these to me and I'll get you outfitted.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'And remember, you can always check your <b:white>[progress]</>")
    self.room:send("</>with me at any time.'")
end