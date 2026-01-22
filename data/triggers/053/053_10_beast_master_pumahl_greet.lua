-- Trigger: Beast Master Pumahl greet
-- Zone: 53, ID: 10
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #5310

-- Converted from DG Script #5310: Beast Master Pumahl greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if not actor:get_has_completed("beast_master") then
    if not actor:get_quest_stage("beast_master") then
        actor:send(tostring(self.name) .. " says, 'Welcome to the Hall of the Hunt, home of the Beast Masters.  We give out assignments to <b:cyan>[hunt]</> and defeat legendary creatures.  Great rewards wait those who prove their mettle.'")
    elseif actor:get_quest_var("beast_master:hunt") == "running" then
        actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  What are you doing here?  If you lost your assignment say, <b:cyan>\"I need a new assignment\"</>.'")
    elseif actor:get_quest_var("beast_master:hunt") == "dead" then
        actor:send(tostring(self.name) .. " says, 'Welcome back!  If your hunt was successful give me your assignment.  If you lost your assignment say, <b:cyan>\"I need a new assignment\"</>.'")
    elseif actor:get_quest_stage("beast_master") >= 1 and not actor:get_has_completed("beast_master") then
        actor:send(tostring(self.name) .. " says, 'Ah, back for another creature to <b:cyan>[hunt]</> I see.'")
    end
    if not actor:get_has_completed("ranger_trophy") and actor.level > 9 and (string.find(actor.class, "Warrior") or string.find(actor.class, "Berserker") or string.find(actor.class, "Ranger") or string.find(actor.class, "Mercenary")) then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to prove your <b:cyan>[skill]</> as a hunter.'")
    end
else
    if (string.find(actor.class, "Ranger") or string.find(actor.class, "Warrior") or string.find(actor.class, "Berserker") or string.find(actor.class, "Mercenary")) and not actor:get_quest_stage("ranger_trophy") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'A new hunter looking to prove your <b:cyan>[skill]</> I see.'")
    elseif actor:get_quest_stage("ranger_trophy") and not actor:get_has_completed("ranger_trophy") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be looking to prove your <b:cyan>[skill]</> again.'")
    end
end