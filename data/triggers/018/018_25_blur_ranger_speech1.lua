-- Trigger: blur_ranger_speech1
-- Zone: 18, ID: 25
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1825

-- Converted from DG Script #1825: blur_ranger_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes ready deeper ways nature deeper? ways? nature?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "ready") or string.find(string.lower(speech), "deeper") or string.find(string.lower(speech), "ways") or string.find(string.lower(speech), "nature") or string.find(string.lower(speech), "deeper?") or string.find(string.lower(speech), "ways?") or string.find(string.lower(speech), "nature?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("blur") == 1 then
    self.room:send("A twinkle shines in " .. tostring(self.name) .. "'s eye.")
    self:say("I had hoped so.")
    actor.name:advance_quest("blur")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'There is a very powerful spell only we warriors of")
    self.room:send("</>nature know.  If you prove yourself worthy, you will be able to learn it as")
    self.room:send("</>well.  Helping the forest was a demonstration of the purity of your spirit, but")
    self.room:send("</>you must now prove your strength.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'There is a warder who failed to protect a massive")
    self.room:send("</>swath of the west from being consumed by the Realm of Dreams.  Since his")
    self.room:send("</>failure, he has become part of the Dream, fallen completely to nightmare.'")
    wait(4)
    self:say("End his suffering and bring me his blade.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Check with me if you want to know your <b:white>[progress]</>.'")
elseif actor:get_quest_stage("blur") == 4 then
    if string.find(speech, "yes") or string.find(speech, "ready") then
        self.room:send(tostring(self.name) .. " says, 'You will only have one day to race all four winds,")
        self.room:send("</>and even less time for each wind individually.'")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'If after one day you have not completed all four")
        self.room:send("</>of their challenges, you will have to come back to me to start again.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'When you are ready, say <b:white>[let's begin]</>.'")
    end
elseif actor:get_has_failed("blur") and (string.find(speech, "yes") or string.find(speech, "ready")) then
    actor.name:restart_quest("blur")
    actor.name:advance_quest("blur")
    actor.name:advance_quest("blur")
    actor.name:advance_quest("blur")
    self.room:send(tostring(self.name) .. " says, 'Then you will need to find the winds again and race them.")
    self.room:send("</>You have one day to complete their challenges.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'When you are ready, say <b:white>[let's begin]</>.'")
end