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
if not (string.find(s, "yes") or string.find(s, "sure") or string.find(s, "yep") or string.find(s, "okay")) then
    return true
end

wait(2)
if string.find(actor.class, "Cryomancer") then
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