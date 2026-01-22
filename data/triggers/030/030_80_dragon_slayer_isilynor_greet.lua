-- Trigger: Dragon Slayer Isilynor Greet
-- Zone: 30, ID: 80
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #3080

-- Converted from DG Script #3080: Dragon Slayer Isilynor Greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local anti = "Anti-Paladin"
if not actor:get_has_completed("dragon_slayer") then
    if not actor:get_quest_stage("dragon_slayer") then
        if actor.level > 4 then
            actor:send(tostring(self.name) .. " says, 'Hail!  I am Isilynor, Grand Master of the Knights of Dragonfire, a guild of professional dragon slayers.  We're always seeking bold recruits to <b:cyan>[hunt]</> the great dragons of the world.  I reward those who put their mettle to the test.'")
        end
    elseif actor:get_quest_var("dragon_slayer:hunt") == "running" then
        actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  What are you doing here?  If you lost your notice say <b:cyan>\"I need a new notice\"</>.'")
    elseif actor:get_quest_var("dragon_slayer:hunt") == "dead" then
        actor:send(tostring(self.name) .. " says, 'Welcome back!  If your hunt was successful give me your notice.  If you lost your notice say <b:cyan>\"I need a new notice\"</>.'")
    elseif actor:get_quest_stage("dragon_slayer") >= 1 and not actor:get_has_completed("dragon_slayer") then
        actor:send(tostring(self.name) .. " says, 'Ah, back for another dragon to <b:cyan>[hunt]</> I see.'")
    end
    if not actor:get_has_completed("paladin_pendant") and actor.level > 9 and (string.find(actor.class, "Paladin") or string.find(actor.class, "anti")) then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to discuss your <b:cyan>[devotion]</> to the cause.'")
    end
else
    if (string.find(actor.class, "Paladin") or actor.class == "anti") and not actor:get_quest_stage("paladin_pendant") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'A new recruit looking to prove your <b:cyan>[devotion]</> to the cause.'")
    elseif actor:get_quest_stage("paladin_pendant") and not actor:get_has_completed("paladin_pendant") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be looking to prove your <b:cyan>[devotion]</> again.'")
    end
end