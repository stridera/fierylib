-- Trigger: megalith_quest_priestess_speech_invocation1
-- Zone: 123, ID: 9
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12309

-- Converted from DG Script #12309: megalith_quest_priestess_speech_invocation1
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"great"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local speech1 = "great lady of the stars hear our prayer"
local speech2 = "great lady of the stars, hear our prayer"
local speech3 = "great lady of the stars, hear our prayer!"
local stage = actor:get_quest_stage("megalith_quest")
if speech == speech1 or speech == speech2 or speech == speech3 then
    if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and (actor:get_quest_var("megalith_quest:prayer") == 1) then
        run_room_trigger(123, 17)
        wait(5)
        self.room:send(tostring(self.name) .. " chants:")
        self.room:send("</>'We call you from the realm behind")
        self.room:send("</>One adrift beyond space and time.")
        -- (empty room echo)
        self.room:send("</>Ringing now the bell in three")
        self.room:send("</>Hear our prayer")
        self.room:send("</><b:cyan>We summon and stir thee</>!'")
        actor:set_quest_var("megalith_quest", "prayer", 2)
        actor:set_quest_var("megalith_quest", "summon", 1)
    end
end