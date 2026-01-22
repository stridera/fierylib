-- Trigger: Wizard Eye Master Shaman receive 4
-- Zone: 550, ID: 45
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55045

-- Converted from DG Script #55045: Wizard Eye Master Shaman receive 4
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("wizard_eye")
if stage == 11 then
    wait(2)
    actor.name:advance_quest("wizard_eye")
    self:emote("admires the crystal ball.")
    actor:send(tostring(self.name) .. " says, 'Truly a perfect tool for scrying.  It suits you.  Keep it and treasure it.'")
    self:command("give crystal-ball " .. tostring(actor.name))
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Everything is prepared!'")
    self:emote("retrieves the poultice, the sachet, and the incense.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'First, the poultice.'")
    self:emote("scoops up some of the pungent poultice and smears it on the crystal ball.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Now your turn " .. tostring(actor.name) .. "'")
    actor:send(tostring(self.name) .. " spreads the stinky poultice across your face.  Yuck!")
    self.room:send_except(actor, tostring(self.name) .. " spreads the stinky poultice across " .. tostring(actor.name) .. "'s face.")
    actor:command("gag")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Next the sachet.'")
    self:emote("lays out a pillow and places the herbal sachet beneath it.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'And now, the incense.'")
    self:emote("lights the incense.")
    actor:send("The sweet smell of roses and cinnamon fills the chamber.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Now, all that's left is for you to <b:cyan>sleep</>, " .. tostring(actor.name) .. ".'")
end