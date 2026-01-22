-- Trigger: ice_shards_khysan_speech3
-- Zone: 103, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10312

-- Converted from DG Script #10312: ice_shards_khysan_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes sure yep okay
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "sure") or string.find(string.lower(speech), "yep") or string.find(string.lower(speech), "okay")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "Cryomancer") then
    if actor.level > 88 and actor:get_quest_stage("ice_shards") == 0 then
        actor.name:start_quest("ice_shards")
        self:command("beam")
        self:say("Excellent!  I'm excited!")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'If you need, you can check your <b:cyan>[ice shards progress]</> with me.'")
    elseif actor.level > 88 and actor:get_quest_stage("ice_shards") > 0 then
        self:say("Oh please do share!")
    elseif actor.level =< 88 then
        self.room:send(tostring(self.name) .. " says, 'I appreciate your enthusiasm, but it's probably too")
        self.room:send("</>dangerous, right?'")
    end
end