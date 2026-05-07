-- Trigger: Ill-subclass: Grand Master greeting
-- Zone: 172, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- When a player enters: pitch the illusionist subclass quest to eligible
-- sorcerers (level 10-45), and offer a hint to anyone already mid-quest who
-- hasn't completed it yet.
--
-- Original DG Script: #17201

if string.find(actor.class, "Sorcerer") and actor.level >= 10 and actor.level <= 45 then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Hello, " .. tostring(actor.name) .. ".'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'm looking for bright young sorcerers like yourself to become illusionists.  But I need evidence of your dedication...  And resourcefulness.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Do you have time to do a small favor for me?'")
end

if not actor:get_has_completed("illusionist_subclass") and actor:get_quest_stage("illusionist_subclass") > 0 then
    wait(1)
    self:command("smile " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Quest going well, I hope?  Say <b:cyan>'help'</> if you're having any trouble.'")
end