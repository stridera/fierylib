-- Trigger: ice_shards_khysan_speech3
-- Zone: 103, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10312
-- The "yes" follow-up. If a high-level cryomancer agrees to help
-- track down the books, starts the ice_shards quest. Players
-- under L89 are politely turned away.

local s = string.lower(speech)

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "sure", "yep", "okay"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

wait(0.2)
if string.find(actor.class, "cryomancer") then
    if actor.level > 88 and actor:get_quest_stage("ice_shards") == 0 then
        actor:start_quest("ice_shards")
        self:command("beam")
        self:say("Excellent!  I'm excited!")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'If you need, you can check your <b:cyan>[ice shards progress]</> with me.'")
    elseif actor.level > 88 and actor:get_quest_stage("ice_shards") > 0 then
        self:say("Oh please do share!")
    elseif actor.level <= 88 then
        self.room:send(tostring(self.name) .. " says, 'I appreciate your enthusiasm, but it's probably too")
        self.room:send("</>dangerous, right?'")
    end
end