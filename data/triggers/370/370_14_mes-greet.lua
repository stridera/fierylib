-- Trigger: mes-greet
-- Zone: 370, ID: 14
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN (reviewed 2026-01-22)
--
-- Original DG Script: #37014

-- Converted from DG Script #37014: mes-greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if string.find(actor.race, "troll") then
    if actor:get_quest_stage("troll_quest") ~= 1 then
        actor:send(tostring(self.name) .. " says to you, 'Welcome!  It has been many years indeed since I have had the pleasure of conversing with another troll from the lands above.'")
        actor:send(tostring(self.name) .. " says to you, 'Unfortunately my research has kept me belowground and  far from the swamps of our home.'")
        self:command("sigh")
        wait(3)
        self:command("consider " .. tostring(actor.name))
        if actor.level >= 55 then
            actor:send(tostring(self.name) .. " says to you, 'It looks like we are still the strongest of the clans, my friend.  Perhaps we can help each other.'")
            actor:start_quest("troll_quest")
            actor:send(tostring(self.name) .. " says to you, 'Long ago, some powerful items of the trolls were stolen by jealous Shamen from different tribes and hidden away.'")
            actor:send(tostring(self.name) .. " says to you, 'If you were to bring the objects back to me, I could reward you quite handsomely.'")
            wait(1)
            actor:send(tostring(self.name) .. " says to you, 'One is the the bough of a sacred mangrove tree that stood in the courtyard of a great troll palace before it was destroyed by a feline god of the snows.'")
            wait(1)
            actor:send(tostring(self.name) .. " says to you, 'One is a vial of red dye made from the blood of our enemies, stolen by a tribe in a canyon who wished to unlock its power.'")
            wait(1)
            actor:send(tostring(self.name) .. " says to you, 'One is a large hunk of malachite, a stone we have always valued for its deep green color.  Our enemies the swamp lizards also liked its color, however, and guard it jealously.'")
            wait(2)
            actor:send(tostring(self.name) .. " says to you, 'I am sure you can restore our lost honor.  Return them to me and the power of the Trolls shall be known once again!'")
            local troll_quest = 1
            globals.troll_quest = globals.troll_quest or true
        else
            self:command("wink " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says to you, 'Come back to me when you have grown a bit and I shall see what we can do for each other, young one.'")
        end
    elseif actor:get_quest_stage("troll_quest") == 1 then
        actor:send(tostring(self.name) .. " says to you, 'Welcome back!  If you have the items, give them to me.'")
    end
else
    self:command("frown")
    actor:send(tostring(self.name) .. " says to you, 'And what exactly are YOU doing here?!'")
    wait(1)
    self:command("sigh")
    actor:send(tostring(self.name) .. " says to you, 'No, do not answer.  It seems I shall have to deal with you myself after all.'")
    actor:send(tostring(self.name) .. " says to you, 'You must be quite resourceful to have found me, but I cannot be bothered just now.  Leave me.'")
    wait(2)
    self.room:send(tostring(self.name) .. " turns away from you.")
    actor:send(tostring(self.name) .. " says, 'Or attack me, if you are feeling particularly stupid.'")
end