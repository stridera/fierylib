-- Trigger: wild-hunt-rag-held
-- Zone: 484, ID: 18
-- Type: MOB, Flags: GLOBAL, GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #48418

-- Converted from DG Script #48418: wild-hunt-rag-held
-- Original: MOB trigger, flags: GLOBAL, GREET_ALL, probability: 100%
-- Checks to see if the actor is indeed holding the rag like they should be
-- for the doom entry quest.
if actor:get_quest_stage("doom_entrance") == 1 then
    if actor:has_equipped("48430") then
        if self.id == 55214 then
            self.room:send("The deer flees wildly at the sight of the blood-soaked rag!")
            self:command("flee")
        elseif self.id == 55244 then
            self.room:send("The deer boldly stands its ground, nostrils flaring at the scent of blood.")
        end
    end
end