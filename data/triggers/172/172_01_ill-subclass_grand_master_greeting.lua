-- Trigger: Ill-subclass: Grand Master greeting
-- Zone: 172, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #17201

-- Converted from DG Script #17201: Ill-subclass: Grand Master greeting
-- Original: MOB trigger, flags: GREET, probability: 100%
-- switch case is inverted with case 0 starting and all cases after 2 as default
-- switch on actor:get_quest_stage("illusionist_subclass")
if string.find(actor.class, "Sorcerer") then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- break
    if actor.level >= 10 and actor.level <= 45 then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Hello, " .. tostring(actor.name) .. ".'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I'm looking for bright young sorcerers like yourself to become illusionists.  But I need evidence of your dedication...  And resourcefulness.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Do you have time to do a small favor for me?'")
    end
end
-- Don't do anything - they're on their way to the hideout, and might be
-- slightly confused as to the best way out of the Citadel, or just cleaning
-- up here on the top floor.
if not actor:get_has_completed("illusionist_subclass") then
    -- Quester dropped the vial, but wasn't in the Smuggler leader's room when
    -- the invasion illusion started.  Quester needs help.
    wait(1)
    self:command("smile " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Quest going well, I hope?  Say <b:cyan>'help'</> if you're having any trouble.'")
end