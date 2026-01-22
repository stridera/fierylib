-- Trigger: Honus Treasure Hunter greet
-- Zone: 53, ID: 20
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #5320

-- Converted from DG Script #5320: Honus Treasure Hunter greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if not actor:get_has_completed("treasure_hunter") then
    if not actor:get_quest_stage("treasure_hunter") then
        actor:send(tostring(self.name) .. " says, 'Well hello and welcome!  I'm Honus, global representative of the Guild of Treasure Hunters.  We're always seeking bold explorers to <b:cyan>[hunt]</> down and recover exquisite rarities.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'We pay well, of course.'")
    elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
        actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  What are you doing here?  If you lost your order say, <b:cyan>\"I need a new order\".</>'")
    elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
        actor:send(tostring(self.name) .. " says, 'Welcome back!  If your hunt was successful give me your order.  If you lost your order say, <b:cyan>\"I need a new order\".</>'")
    elseif actor:get_quest_stage("treasure_hunter") >= 1 and not actor:get_has_completed("treasure_hunter") then
        actor:send(tostring(self.name) .. " says, 'Ah, back to <b:cyan>[hunt]</> for more treasure!'")
    end
    if not actor:get_has_completed("rogue_cloak") and actor.level > 9 and (string.find(actor.class, "Rogue") or string.find(actor.class, "Thief") or string.find(actor.class, "Bard")) then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to seek a <b:cyan>[promotion]</>.'")
    end
else
    if (string.find(actor.class, "Rogue") or string.find(actor.class, "Thief") or string.find(actor.class, "Bard")) and not actor:get_quest_stage("rogue_cloak") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'Oh look, a new recruit gunning for a <b:cyan>[promotion]</>.'")
    elseif actor:get_quest_stage("rogue_cloak") and not actor:get_has_completed("rogue_cloak") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be looking for another <b:cyan>[promotion]</>.'")
    end
end