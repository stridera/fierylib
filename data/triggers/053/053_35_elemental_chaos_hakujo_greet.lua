-- Trigger: Elemental Chaos Hakujo greet
-- Zone: 53, ID: 35
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #5335

-- Converted from DG Script #5335: Elemental Chaos Hakujo greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if not actor:get_has_completed("elemental_chaos") then
    if not actor:get_quest_stage("elemental_chaos") then
        self:command("bow")
        actor:send(tostring(self.name) .. " says, 'Welcome wanderer.  I have not seen the likes of you before.'")
        wait(2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Though now that I get a look at you, perhaps you can assist in our <b:cyan>[mission]</>.'")
    elseif actor:get_quest_var("elemental_chaos:bounty") == "running" then
        actor:send(tostring(self.name) .. " says, 'What are you doing here so soon?  You still have a mission to accomplish.  If you misplaced it, say, <b:cyan>\"I need a new note\"</>.'")
    elseif actor:get_quest_var("elemental_chaos:bounty") == "dead" then
        actor:send(tostring(self.name) .. " says, 'If you completed the deed, give me your mission.  If you misplaced it, say, <b:cyan>\"I need a new note\"</>.'")
    elseif actor:get_quest_stage("elemental_chaos") >= 1 and not actor:get_has_completed("elemental_chaos") then
        actor:send(tostring(self.name) .. " says, 'Ah, I have <b:cyan>[news]</> for you.'")
    end
    wait(1)
    if not actor:get_quest_stage("monk_vision") and actor.level > 9 and string.find(actor.class, "Monk") then
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to discuss <b:cyan>[enlightenment]</>.'")
    elseif actor.level > 9 and string.find(actor.class, "Monk") then
        actor:send(tostring(self.name) .. " says, 'Or have you come to seek further <b:cyan>[enlightenment]</>.'")
    end
else
    if string.find(actor.class, "Monk") and not actor:get_quest_stage("monk_vision") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'Oh look, someone else in line for a <b:cyan>[enlightenment]</>.'")
    elseif actor:get_quest_stage("monk_vision") and not actor:get_has_completed("monk_vision") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be seeking further <b:cyan>[enlightenment]</>.'")
    end
end