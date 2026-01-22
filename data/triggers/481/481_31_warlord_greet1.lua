-- Trigger: warlord_greet1
-- Zone: 481, ID: 31
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48131

-- Converted from DG Script #48131: warlord_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    self:emote("looks up quickly as you enter.")
    self:command("sigh")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I live in hope that my son will survive and return to me one day.'")
end