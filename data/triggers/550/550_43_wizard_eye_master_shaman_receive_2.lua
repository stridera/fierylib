-- Trigger: Wizard Eye Master Shaman receive 2
-- Zone: 550, ID: 43
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55043

-- Converted from DG Script #55043: Wizard Eye Master Shaman receive 2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("wizard_eye")
if stage == 5 then
    wait(2)
    self:destroy_item("sachet")
    actor.name:advance_quest("wizard_eye")
    actor:send(tostring(self.name) .. " says, 'Very smart blend of herbs.  It will bring prophetic dreams.  She always did know her sachets.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I will store it for you.'")
    actor:send(tostring(self.name) .. " tucks the herbal sachet away in her chamber.")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'I believe it's time to <b:cyan>visit the witchy woman who runs the apothecary in Anduin</>.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Like the others you have visited, she has no name any can recall, simply going by \"the Green Woman.\"'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Though she may not look like much, she is both a powerful diviner and a master of secrets.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Other peoples' secrets.  Which she sells to the highest bidder.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'See what she recommends.  Surely she has a trick or two up her sleeve.'")
end