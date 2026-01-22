-- Trigger: Berix bounty hunt greet
-- Zone: 60, ID: 50
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #6050

-- Converted from DG Script #6050: Berix bounty hunt greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if not actor:get_has_completed("bounty_hunt") then
    if not actor:get_quest_stage("bounty_hunt") then
        if actor.alignment <= -350 or string.find(actor.class, "Assassin") or string.find(actor.class, "Mercenary") then
            actor:send(tostring(self.name) .. " says, 'Well hello there.  You look like quite a piece of work.  I think I have a <b:cyan>[job]</> for you.'")
        else
            actor:send(tostring(self.name) .. " says, 'What do you want?'")
        end
    elseif actor:get_quest_var("bounty_hunt:bounty") == "running" then
        actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  What are you doing here?  If you lost your contract like a moron, say, <b:cyan>\"I need a new contract\"</>.'")
    elseif actor:get_quest_var("bounty_hunt:bounty") == "dead" then
        actor:send(tostring(self.name) .. " says, 'If you got the job done, give me your contract.  If you lost your contract like a moron, say, <b:cyan>\"I need a new contract\"</>.'")
    elseif actor:get_quest_stage("bounty_hunt") >= 1 and not actor:get_has_completed("bounty_hunt") then
        actor:send(tostring(self.name) .. " says, 'Ah, back for another <b:cyan>[job]</> I see.'")
    end
    if not actor:get_has_completed("assassin_mask") and actor.level > 9 and string.find(actor.class, "Assassin") then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to discuss a <b:cyan>[promotion]</>.'")
    end
else
    if string.find(actor.class, "Assassin") and not actor:get_quest_stage("assassin_mask") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'Oh look, someone else in line for a <b:cyan>[promotion]</>.'")
    elseif actor:get_quest_stage("assassin_mask") and not actor:get_has_completed("assassin_mask") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be looking for another <b:cyan>[promotion]</>.'")
    end
end