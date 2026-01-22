-- Trigger: word_command_dargo_greet
-- Zone: 430, ID: 52
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #43052

-- Converted from DG Script #43052: word_command_dargo_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if self.room == 43148 then
    if questor then
        self:say("Thank the gods you found me again!  Help me get out of here!")
    elseif (string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist")) and actor.level > 72 then
        self:say("Oh thank the gods, please help me!  Someone used a scroll")
        self.room:send("</>of World Teleport on me as a joke and I wound up here!'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'I've been trying desperately to escape this place but every")
        self.room:send("</>time I think I found a way out, the demon reaper who rules this place")
        self.room:send("</>keeps pulling me back.'")
        wait(2)
        self:say("I don't know how long I've been down here...")
        self:command("sob")
        wait(2)
        self:say("Help me confront the demon and his servants and destroy them!")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'If you can get me out of this hell, I can teach you a")
        self.room:send("</>powerful spell.  Will you help me?'")
    else
        self:say("Do you have any priestly friends who can protect us from the")
        self.room:send("</>demon who rules this keep??  Or even someone who knows the demonic arts?'")
    end
end