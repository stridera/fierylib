-- Trigger: flood_lady_greet
-- Zone: 390, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #39001

-- Converted from DG Script #39001: flood_lady_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
local stage = actor:get_quest_stage("flood")
if stage == 0 then
    if string.find(actor.class, "Cryomancer") and actor.level > 80 then
        self:command("point " .. tostring(actor))
        self:emote("screams, 'YOU.'")
        wait(2)
        self:emote("screams, 'YOU WILL HELP ME DESTROY THIS SETTLEMENT.'")
    end
else
    if stage == 1 then
        self.room:send(tostring(self.name) .. " says, 'Why have you not yet convinced the other great")
        self.room:send("</>waters to assist me??'")
        self:emote("fumes.")
    elseif stage == 2 then
        self.room:send(tostring(self.name) .. " says, 'The waters are ready!  Give me back the heart and")
        self.room:send("</>the ocean will rage!'")
    end
end