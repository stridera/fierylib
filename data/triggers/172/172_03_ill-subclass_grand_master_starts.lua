-- Trigger: Ill-subclass: Grand Master starts
-- Zone: 172, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #17203

-- Converted from DG Script #17203: Ill-subclass: Grand Master starts
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: begin
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "begin")) then
    return true  -- No matching keywords
end
-- switch on actor:get_quest_stage("illusionist_subclass")
if string.find(actor.class, "Sorcerer") then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- if %actor.level% >= 10 && %actor.level% <= 45
    -- msend %actor% &1Your race may not subclass to illusionist.&0
    -- endif
    -- break
    if actor.level >= 10 and actor.level <= 45 then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Good, good.  Please stand still while I enchant you so that the smugglers will see you as Cestia.'")
        wait(3)
        self:emote("utters the words, 'incognito'.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Now... take this vial.'")
        self.room:spawn_object(172, 15)
        self:command("give vial " .. tostring(actor.name))
        self:destroy_item("vial")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Now go to the hideout, <b:cyan>drop the vial</>, and quickly go to to see the leader.  Remember not to let anyone see you drop it!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Come back and ask for <b:cyan>help</> if you get stuck!'")
        actor.name:start_quest("illusionist_subclass", "Illusionist")
    end
end
wait(1)
actor.name:erase_quest("illusionist_subclass")
actor:send(tostring(self.name) .. " says, 'Did you have some trouble?  No matter.  I will remove your disguise.'")
wait(2)
actor:send(tostring(self.name) .. " says, 'Say <b:cyan>'begin'</> if you want to try again.  But let me rest a moment first.'")
wait(5)
wait(1)
actor.name:erase_quest("illusionist_subclass")
actor:send(tostring(self.name) .. " says, 'Did you meet with the leader?  I hope the disguise was sufficient.'")
wait(4)
actor:send(tostring(self.name) .. " says, 'Perhaps it would be worthwhile to try again.  The smuggler leader should be searching high and low for Cestia, now.'")
wait(4)
actor:send(tostring(self.name) .. " says, 'If you are willing, I will refresh your disguise for another attempt.  Say <b:cyan>'begin'</> when you are ready.'")
wait(1)
actor:send(tostring(self.name) .. " says, 'Do you have the choker?  Did you lose it?'")
wait(3)
self:command("sigh")
wait(2)
actor:send(tostring(self.name) .. " says, 'Very well.  If you want to try again, say <b:cyan>'restart'</> and I will refresh your magical disguise.'")