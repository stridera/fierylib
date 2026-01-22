-- Trigger: monk_subclass_quest_arre_greet
-- Zone: 51, ID: 5
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #5105

-- Converted from DG Script #5105: monk_subclass_quest_arre_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("monk_subclass")
if actor:get_quest_stage("monk_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'Have you returned to join the Brotherhood?  You will be rewarded for your success with wonderful training, but only those pure of mind will complete the <b:cyan>quest</>.'")
elseif actor:get_quest_stage("monk_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Remember my story.  I long for the return of my prized bronze sash.'")
    wait(1)
    self:emote("shakes her head.")
    actor:send(tostring(self.name) .. " says, 'I was told it looked wonderful on me.  " .. tostring(actor.name) .. ", can you track down these fiends?'")
    self.room:send("</>")
    wait(1)
    actor:send(tostring(self.name) .. " whispers to you, 'Please?'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Long ago some ruthless <b:cyan>fiends</> made off with it.'")
elseif actor:get_quest_stage("monk_subclass") == 3 or actor:get_quest_stage("monk_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Have you recovered my bronze sash from those desert thieves?'")
else
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- halt
    -- break
    if string.find(actor.class, "warrior") and (actor.level >= 10 and actor.level <= 25) then
        self:command("look " .. tostring(actor.name))
        wait(1)
        self:command("snicker")
        actor:send(tostring(self.name) .. " says, 'Well hello, what have you come <b:cyan>here</> for?'")
        self:command("smile " .. tostring(actor.name))
    end
end  -- auto-close block