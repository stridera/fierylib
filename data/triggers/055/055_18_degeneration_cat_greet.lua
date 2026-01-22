-- Trigger: degeneration_cat_greet
-- Zone: 55, ID: 18
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #5518

-- Converted from DG Script #5518: degeneration_cat_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
local stage = actor:get_quest_stage("degeneration")
if string.find(actor.class, "Necromancer") then
    if actor.level > 80 then
        if stage == 0 then
            self.room:send(tostring(self.name) .. " says, 'Ah, finally a visitor worth my attention.  Have you come to")
            self.room:send("</>advance your knowledge of the deathly arts?'")
        elseif stage == 1 then
            self:say("Do you have Yajiro's book?")
        elseif stage == 2 then
            self:say("Do you have Mesmeriz's necklace?")
        elseif stage == 3 then
            self:say("Do you have Luchiaans' mask?")
        elseif stage == 4 then
            self:say("Do you have Voliangloch's rod?")
        elseif stage == 5 then
            self:say("Do you have Kryzanthor's robe?")
        elseif stage == 6 then
            self:say("Do you have Ureal's statuette?")
        elseif stage == 7 or stage == 8 then
            self:say("Do you have Norisent's book?")
        elseif stage == 9 then
            self:say("Do you have the ruby?")
        end
    end
end