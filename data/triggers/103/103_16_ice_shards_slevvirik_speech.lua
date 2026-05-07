-- Trigger: ice_shards_slevvirik_speech
-- Zone: 103, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10316
-- Stage 5 cryptic-information dump: Slevvirik tells the player
-- the Butcher of Anduin was sent to the Plane of Earth via a
-- portal. Advances the quest to stage 6. DG narg=0 = substring.

local s = string.lower(speech)
if not string.find(s, "butcher") then
    return true
end

if actor:get_quest_stage("ice_shards") == 5 then
    actor:advance_quest("ice_shards")
    wait(2)
    self:command("sigh")
    self.room:send(self.name .. " says, 'Yes, I do know where he is and before you ask, no I don't mind")
    self.room:send("</>telling you.  My contractual obligation to him is fulfilled and if I do tell")
    self.room:send("</>you where he is, I doubt it will make much of a difference.'")
    wait(5)
    self.room:send(self.name .. " says, 'That beast knew his reputation was going to catch up to him")
    self.room:send("</>sooner or later.  He paid us to hide him where no one in the world would find")
    self.room:send("</>him.  So we hid him off world.'")
    wait(6)
    self.room:send(self.name .. " says, 'We opened a gateway to the Plane of Earth and sent him on his")
    self.room:send("</>way.  I suppose he's still there.'")
    wait(4)
    self:say("If he's still alive.")
    wait(1)
    self:command("tip " .. actor.name)
end