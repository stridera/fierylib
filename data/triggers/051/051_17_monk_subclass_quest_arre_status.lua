-- Trigger: monk_subclass_quest_arre_status
-- Zone: 51, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5117
--
-- Player says "subclass" or "progress" -- Arre summarizes their position
-- in the monk subclass quest by stage. The greet/intro triggers tell the
-- player to use these keywords, so this must always run on keyword
-- match. Note: legacy DG header listed probability 0% but speech
-- triggers in DG fired on every keyword match regardless of header
-- probability -- the converter's percent_chance(0) gate has been
-- removed.
--
-- TODO(parity): legacy DG had a placeholder for restricted races
-- ("ADD RESTRICTED RACES HERE") which was never filled in.

-- Speech keywords: subclass, progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "subclass") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("monk_subclass")
if stage == 1 then
    wait(2)
    actor:send(self.name .. " says, 'It is wonderful to hear of others wanting to join the Brotherhood of the Monks.  You will be rewarded for your success with wonderful training, but only those pure of mind will complete the <b:cyan>quest</>.'")
elseif stage == 2 then
    wait(2)
    actor:send(self.name .. " says, 'Alright, well sit back.'")
    wait(2)
    actor:send(self.name .. " says, 'Usually people come in here promising me the return of something long lost of mine.'")
    self:command("scratch")
    wait(3)
    actor:send(self.name .. " says, 'The thing is, I have not always lead this life.  When I was young I was quite the rabble-rouser.'")
    self:emote("looks wistfully for a moment.")
    wait(4)
    actor:send(self.name .. " says, 'Well, it is rather embarrassing, but...  I miss my old sash, and I want it back.'")
    wait(2)
    self:emote("shakes her head.")
    actor:send(self.name .. " says, 'I was told it looked wonderful on me.'")
    wait(3)
    actor:send(self.name .. " says, '" .. actor.name .. ", can you recover it?'")
    wait(1)
    actor:send(self.name .. " whispers to you, 'Please?'")
    wait(3)
    actor:send(self.name .. " says, 'Long ago some ruthless <b:cyan>fiends</> made off with it.'")
elseif stage == 3 or stage == 4 then
    wait(2)
    actor:send(self.name .. " says, 'Have you recovered my sash from those thieves out west?  If you return my sash, I will complete your initiation as a monk.'")
elseif not string.find(actor.class, "Warrior") then
    actor:send(self.name .. " says, 'Ah, you are not well suited to my teaching.  So I shall not waste my time with you.'")
else
    wait(2)
    if actor.level < 10 then
        self:command("eye " .. actor.name)
        actor:send(self.name .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
    elseif actor.level <= 25 then
        actor:send(self.name .. " says, 'You are not trying to join the Brotherhood.'")
    else
        actor:send(self.name .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
    end
end