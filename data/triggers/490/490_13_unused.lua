-- Trigger: UNUSED
-- Zone: 490, ID: 13
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49013

-- Converted from DG Script #49013: UNUSED
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 49060 then
    wait(2)
    self:say("Dagon is dead and the altar is broken.")
    self:command("cheer")
    self:say("I felt the trees breathe a sigh of relief at his passing.")
    self:command("think")
    self:say("If you were the mighty one that killed him then")
    self:say("give me his skin and I will help you to ensure his complete destruction.")
    get_room(490, 83):at(function()
        self:command("give dagon-quest-complete griffin-quest-controller")
    end)
end