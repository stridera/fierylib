-- Trigger: degeneration_status_checker
-- Zone: 55, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5522

-- Converted from DG Script #5522: degeneration_status_checker
-- Reminds the actor of their Degeneration quest stage when they say
-- "spell" or "progress". The cat tells the player to use these keywords,
-- so the script must always run on match. Legacy DG header listed
-- probability 0% but the original always ran on keyword match -- the
-- converter's percent_chance(0) gate has been removed.

-- Speech keywords: spell progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("degeneration")
self:say("You are trying to help me finish the spell Degeneration.")
-- (empty room echo)
if stage == 1 then
    self:say("Find Yajiro in Odaishyozen and bring back his book.")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'Find Mesmeriz in the Minithawkin Mines and bring back his")
    self.room:send("</>necklace.'")
elseif stage == 3 then
    self:say("Find Luchiaans in Nordus and bring back his mask.")
elseif stage == 4 then
    self:say("Find Voliangloch in Demise Keep and bring back his rod.")
elseif stage == 5 then
    self:say("Find Kryzanthor in the Graveyard and bring back his robe.")
elseif stage == 6 then
    self.room:send(tostring(self.name) .. " says, 'Find Ureal the Lich in the Barrow and bring back his")
    self.room:send("</>statuette.'")
elseif stage == 7 or stage == 8 then
    self.room:send(tostring(self.name) .. " says, 'Find Norisent in the Cathedral of Betrayal and bring back")
    self.room:send("</>his book.'")
elseif stage == 9 then
    self:say("Find the enormous ruby hidden under a stairway.")
end