-- Trigger: give_chalice_silania
-- Zone: 185, ID: 5
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #18505

-- Converted from DG Script #18505: give_chalice_silania
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
-- stage is set to 3 when chalice retrieved
if actor:get_quest_stage("pri_pal_subclass") == 3 then
    self:emote("beams a huge smile.")
    wait(3)
    self:command("hug " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'You have done me a great service, and earned your place among the truly holy.'")
    self:command("smi")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Type <b:white>'subclass'</> to proceed.'")
    actor.name:complete_quest("pri_pal_subclass")
elseif actor:get_quest_stage("pri_pal_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'Hmmm, jumping the gun a bit aren't we?'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I didn't even tell you the quest yet.'")
else
    actor:send(tostring(self.name) .. " says, 'Thank you greatly for returning this.'")
    self:command("thank " .. tostring(actor.name))
    wait(2)
    if actor:get_quest_stage("pri_pal_subclass") == 2 then
        -- hmm..they got the chalice without running the appropriate trigger
        -- could they be cheating?
        actor:send(tostring(self.name) .. " says, 'Hmm... I don't know how you got hold of this, but I will give you the benefit of the doubt and not fail you.'")
        self:command("poke " .. tostring(actor.name))
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Now... go and get the chalice properly yourself!'")
    else
        actor:send(tostring(self.name) .. " says, 'Shame you were not performing the quest.  Your selfless act would have qualified you for our holy brotherhood.'")
    end
end
-- junk the chalice
self:destroy_item("chalice")