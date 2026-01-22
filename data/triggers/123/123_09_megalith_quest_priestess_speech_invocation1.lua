-- Trigger: megalith_quest_priestess_speech_invocation1
-- Zone: 123, ID: 9
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12309

-- Converted from DG Script #12309: megalith_quest_priestess_speech_invocation1
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: great
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "great")) then
    return true  -- No matching keywords
end
local speech1 = "great lady of the stars hear our prayer"
local speech2 = "great lady of the stars, hear our prayer"
local speech3 = "great lady of the stars, hear our prayer!"
local stage = actor:get_quest_stage("megalith_quest")
if string.find(speech, "speech1") or string.find(speech, "speech2") or string.find(speech, "speech3") then
    if (stage == 4) and (self.room == 12389) and (actor:get_quest_var("megalith_quest:prayer") == 1) then
        run_room_trigger(12317)
        wait(5)
        self.room:send(tostring(self.name) .. " chants:")
        self.room:send("</>'We call you from the realm behind")
        self.room:send("</>One adrift beyond space and time.")
        -- (empty room echo)
        self.room:send("</>Ringing now the bell in three")
        self.room:send("</>Hear our prayer")
        self.room:send("</><b:cyan>We summon and stir thee</>!'")
        actor.name:set_quest_var("megalith_quest", "prayer", 2)
        actor.name:set_quest_var("megalith_quest", "summon", 1)
    end
end