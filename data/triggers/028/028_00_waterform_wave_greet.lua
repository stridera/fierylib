-- Trigger: waterform_wave_greet
-- Zone: 28, ID: 0
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #2800

-- Converted from DG Script #2800: waterform_wave_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local stage = actor:get_quest_stage("waterform")
if stage == 0 then
    if string.find(actor.class, "Cryomancer") then
        self:say("How nice to see someone other than those dreadful pirates.")
        if actor.level > 72 then
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'Oh, and such a capable water master too.  I could offer")
            self.room:send("</>you a modicum of protection against those pirates if you like.  Would you be")
            self.room:send("</>interested?'")
        end
    end
elseif stage == 1 then
    self:say("Did you find a piece of armor made of water?")
elseif stage == 2 then
    self:say("You should be out killing Tri-Aszp.")
elseif stage == 3 then
    self:say("Have you found a suitably large white dragon bone?")
elseif stage == 4 or stage == 5 then
    self:say("Ah, how are your water creature sample studies going?")
elseif stage == 6 then
    self:say("Do you need to confer about your notes on water sources?")
elseif stage == 7 then
    self:command("peer " .. tostring(actor))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Ah I can see you have gleaned secrets from the waters!")
    self.room:send("</>Give me the dragon bone cup when you're ready.'")
end