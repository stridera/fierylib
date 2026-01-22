-- Trigger: Spark pixy offers help
-- Zone: 615, ID: 4
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #61504

-- Converted from DG Script #61504: Spark pixy offers help
-- Original: MOB trigger, flags: GREET, probability: 100%
if string.find(direction, "north") and heart_inplace ~= 1 and actor.id == -1 and actor.level < 100 then
    wait(1)
    if actor.room ~= self.room then
        return _return_value
    end
    self.room:send_except(actor.name, tostring(self.name) .. " bows before " .. tostring(actor.name) .. " (as much as a flying pixie can).")
    actor:send(tostring(self.name) .. " bows before you, rather well for someone flying in midair.")
    wait(1)
    if actor.room ~= self.room then
        return _return_value
    end
    self:say("If you're having trouble with the fog, I might be able to help.")
    self:say("Would you like me to help?")
    local person_to_help = actor.name
    globals.person_to_help = globals.person_to_help or true
    local greeted_someone = 1
    globals.greeted_someone = globals.greeted_someone or true
    wait(1)
end