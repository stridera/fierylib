-- Trigger: doom_minstrel_play
-- Zone: 489, ID: 0
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48900

-- Converted from DG Script #48900: doom_minstrel_play
-- Original: MOB trigger, flags: RANDOM, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
if self:has_equipped("48924") then
    self:command("remove instrument-case")
    self:command("open instrument-case")
    self:command("get mandolin instrument-case")
    self:command("hold mandolin")
    self:command("sit")
    wait(2)
    self.room:send(tostring(self.name) .. " begins to play a mandolin softly.")
    wait(2)
    self.room:send("The music builds into a swelling crescendo.")
    self.room:send_to_adjacent("Beautiful music floats in from somewhere nearby.")
    wait(4)
    self.room:send("The music begins to fade as " .. tostring(self.name) .. " wraps up the piece.")
    self.room:send_to_adjacent("The music fades away.")
    wait(2)
    self.room:send(tostring(self.name) .. " stops playing.")
    self:command("stand")
    self:command("bow")
    wait(2)
    self:command("put mandolin instrument-case")
    self:command("close instrument-case")
    self:command("wear instrument-case")
end