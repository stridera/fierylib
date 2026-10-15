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

-- The DG switch on the quest stage: case 0 greets a sorcerer and falls through to
-- case 1 (a no-op, then break); stage 1 does nothing; every later stage is the default.
local stage = actor:get_quest_stage("illusionist_subclass")
if stage == 0 then
    if string.find(actor.class, "sorcerer") and actor.level >= 10 and actor.level <= 45 then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Hello, " .. tostring(actor.name) .. ".'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I'm looking for bright young sorcerers like yourself to become illusionists.  But I need evidence of your dedication...  And resourcefulness.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Do you have time to do a small favor for me?'")
    end
end

if stage > 1 and not actor:get_has_completed("illusionist_subclass") then
    wait(1)
    self:command("smile " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Quest going well, I hope?  Say <b:cyan>'help'</> if you're having any trouble.'")
end