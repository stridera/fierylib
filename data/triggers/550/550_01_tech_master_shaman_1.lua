-- Trigger: Tech_Master_Shaman_1
-- Zone: 550, ID: 1
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--   Large script: 5197 chars
--
-- Original DG Script: #55001

-- Converted from DG Script #55001: Tech_Master_Shaman_1
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- Add Kourrya 6-06, loading for the Minithawkin troll mask quest
if string.find(actor.race, "troll") then
    self:destroy_item("mangrove-branch")
    self.room:spawn_object(370, 80)
end
wait(2)
-- 
-- for Wizard Eye
-- 
if ((string.find(actor.class, "Sorcerer") or string.find(actor.class, "Illusionist")) and actor.level > 80) or actor.quest_stage["type_wand"] == 5 then
    if (string.find(actor.class, "Sorcerer") or string.find(actor.class, "Illusionist")) and actor.level > 80 then
        local stage = actor:get_quest_stage("wizard_eye")
        -- switch on stage
        if stage == 1 then
            actor:send(tostring(self.name) .. " tells you, 'You best seek out the gypsy witch.  Without her advice, I cannot help you further.'")
        elseif stage == 2 then
            actor:send(tostring(self.name) .. " tells you, 'Have you brought what the witch suggested?'")
        elseif stage == 3 or stage == 4 then
            actor:send(tostring(self.name) .. " tells you, 'How is the Seer in her cave on Griffin Isle?  I have not seen her for many years!'")
        elseif stage == 5 then
            actor:send(tostring(self.name) .. " tells you, 'Have you brought what the Seer suggested?'")
        elseif stage == 6 or stage == 7 then
            actor:send(tostring(self.name) .. " tells you, 'Before you return to me, speak with the Green Woman in Anduin.  She has learned a great many things from her post behind the counter.'")
        elseif stage == 8 then
            actor:send(tostring(self.name) .. " tells you, 'Have you brought what the Green Woman suggested?'")
        elseif stage == 9 or stage == 10 then
            actor:send(tostring(self.name) .. " tells you, 'The orbs are far too dangerous to bring back here without consulting the Oracle of Justice!'")
            if actor:has_item("3218") or actor:has_item("53424") or actor:has_item("43021") or actor:has_item("4003") or actor:has_equipped("3218") or actor:has_equipped("53424") or actor:has_equipped("43021") or actor:has_equipped("4003") then
                actor:send(tostring(self.name) .. " tells you, 'Leave my chamber before these orbs corrupt it!'")
                actor:send(tostring(self.name) .. " shoves you back out into the hallway!")
                self.room:send_except(actor, tostring(self.name) .. " shoves " .. tostring(actor.name) .. " back out into the hallway!")
                actor.name:teleport(get_room(550, 73))
                get_room(550, 73):at(function()
                    -- actor.name looks around
                end)
            end
        elseif stage == 11 then
            actor:send(tostring(self.name) .. " tells you, 'I see you have returned enlightened!  Let me see the crystal ball and I shall make the preparations.'")
        elseif stage == 12 then
            actor:send(tostring(self.name) .. " tells you, 'Come, <b:cyan>sleep</>, let your dreams impart mastery of divination to you.'")
        else
            if not actor:get_has_completed("wizard_eye") then
                actor:send(tostring(self.name) .. " tells you, 'You are more powerful than most visitors.  Have you come to see as the Great Snow Leopard does?'")
            end
        end
        if actor.quest_stage["type_wand"] == 5 then
            if actor.quest_variable["type_wand:greet"] == 0 then
                self:command("peer " .. tostring(actor))
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'Or perhaps you come about a crafting <b:cyan>[upgrade]</>...'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Or have you brought the necessary components for the wand?'")
            end
        end
    end
    -- 
    -- for phase wands
    -- 
    if actor.quest_stage["type_wand"] == 5 then
        local job1 = actor.quest_stage["type_wand:wandtask1"]
        local job2 = actor.quest_stage["type_wand:wandtask2"]
        local job3 = actor.quest_stage["type_wand:wandtask3"]
        local job4 = actor.quest_stage["type_wand:wandtask4"]
        if actor.level >= 40 then
            if actor.quest_variable["type_wand:greet"] == 0 then
                actor:send(tostring(self.name) .. " tells you, 'I see you're crafting something.  If you come for the Great Snow Leopard's help, let's discuss an <b:cyan>[upgrade]</>.'")
            elseif actor.quest_stage["type_wand"] == 5 and job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " tells you, 'It looks like the wand is ready for upgrading!  Please give it to me.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Do you have what I need for the wand?'")
            end
        end
    end
    -- 
    -- This is the original greet trig for the shaman quest
    -- 
else
    actor:send(tostring(self.name) .. " raises an eyebrow.")
    actor:send(tostring(self.name) .. " mutters something about people disturbing her while she considers what to do about what's missing.")
    actor:send(tostring(self.name) .. " grumbles incoherently about something or other.")
end