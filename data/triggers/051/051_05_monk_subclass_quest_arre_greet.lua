-- Trigger: monk_subclass_quest_arre_greet
-- Zone: 51, ID: 5
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #5105

-- Converted from DG Script #5105: monk_subclass_quest_arre_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
--
-- Greets monk-quest visitors with a stage-appropriate line. New visitors
-- (no quest yet) get the recruitment opener if they're a warrior of the
-- right level band.
--
-- TODO(parity): legacy DG had a placeholder for restricted races
-- ("ADD RESTRICTED RACES HERE") which was never filled in. If a race
-- block is desired, add it before the warrior class/level check.
wait(2)
local stage = actor:get_quest_stage("monk_subclass")
if stage == 1 then
    actor:send(self.name .. " says, 'Have you returned to join the Brotherhood?  You will be rewarded for your success with wonderful training, but only those pure of mind will complete the <b:cyan>quest</>.'")
elseif stage == 2 then
    actor:send(self.name .. " says, 'Remember my story.  I long for the return of my prized bronze sash.'")
    wait(1)
    self:emote("shakes her head.")
    actor:send(self.name .. " says, 'I was told it looked wonderful on me.  " .. actor.name .. ", can you track down these fiends?'")
    self.room:send("</>")
    wait(1)
    actor:send(self.name .. " whispers to you, 'Please?'")
    wait(2)
    actor:send(self.name .. " says, 'Long ago some ruthless <b:cyan>fiends</> made off with it.'")
elseif stage == 3 or stage == 4 then
    actor:send(self.name .. " says, 'Have you recovered my bronze sash from those desert thieves?'")
elseif string.find(actor.class, "warrior") and actor.level >= 10 and actor.level <= 25 then
    self:command("look " .. actor.name)
    wait(1)
    self:command("snicker")
    actor:send(self.name .. " says, 'Well hello, what have you come <b:cyan>here</> for?'")
    self:command("smile " .. actor.name)
end