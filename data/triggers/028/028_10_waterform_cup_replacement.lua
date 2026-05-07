-- Trigger: waterform_cup_replacement
-- Zone: 28, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: REVIEWED (nil-safe stage check; phrase match tightened; cup-flag check fixed)
--
-- Original DG Script: #2810
-- The Great Wave: if a player past stage 3 lost their dragon bone cup, they
-- can say "I need a new cup" to flag the quest var and have the wave accept
-- a fresh white dragon thigh bone (handled in 028_02).
-- Note: the original DG script was probability 0% (effectively disabled),
-- but 028_07 advertises this exact phrase to the player, so we treat it as
-- 100%.

-- Match the full advertised phrase rather than any single keyword.
local speech_lower = string.lower(speech or "")
if not string.find(speech_lower, "new cup") then
    return true
end
wait(2)
local stage = actor:get_quest_stage("waterform")
if stage and stage > 3 and actor:get_quest_var("waterform:new") ~= "yes" then
    actor:set_quest_var("waterform", "new", "yes")
    self:say("Oh no, you lost the cup??")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Well, I can make a new one, but you'll need to find the")
    self.room:send("</>base materials again.'")
    wait(2)
    self:say("Go find another acceptable dragon bone.")
end
return true