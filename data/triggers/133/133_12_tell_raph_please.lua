-- Trigger: tell_raph_Please
-- Zone: 133, ID: 12
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--   Large script: 8481 chars
--
-- Original DG Script: #13312

-- Converted from DG Script #13312: tell_raph_Please
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
if actor.id == -1 then
    if actor.quest_stageget_raph_food == 9 then
        actor.name:complete_quest("get_raph_food")
        if string.find(actor.class, "Cleric") then
            self:command("smile " .. tostring(actor.name))
            skills.set_level(actor.name, "'group heal' 1000", 100)
            if actor.level < 57 then
                actor.name:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
            end
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        elseif string.find(actor.class, "Priest") then
            self:command("smile " .. tostring(actor.name))
            skills.set_level(actor.name, "'group heal' 1000", 100)
            if actor.level < 57 then
                actor.name:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
            end
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        elseif string.find(actor.class, "Diabolist") then
            self:command("smile " .. tostring(actor.name))
            skills.set_level(actor.name, "'group heal' 1000", 100)
            if actor.level < 57 then
                actor.name:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
            end
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        elseif string.find(actor.class, "Druid") then
            self:command("smile " .. tostring(actor.name))
            skills.set_level(actor.name, "'invigorate' 1000", 100)
            if actor.level < 65 then
                actor.name:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
            end
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        elseif string.find(actor.class, "Sorcerer") then
            self:command("smile " .. tostring(actor.name))
            skills.set_level(actor.name, "'major globe' 1000", 100)
            if actor.level < 57 then
                actor.name:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
            end
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        elseif string.find(actor.class, "Pyromancer") then
            self:command("smile " .. tostring(actor.name))
            skills.set_level(actor.name, "'major globe' 1000", 100)
            if actor.level < 57 then
                actor.name:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
            end
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        elseif string.find(actor.class, "Cryomancer") then
            self:command("smile " .. tostring(actor.name))
            skills.set_level(actor.name, "'major globe' 1000", 100)
            if actor.level < 57 then
                actor.name:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
            end
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        elseif string.find(actor.class, "Necromancer") then
            self:command("smile " .. tostring(actor.name))
            skills.set_level(actor.name, "'summon dracolich' 1000", 100)
            if actor.level < 73 then
                actor.name:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
            end
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        elseif string.find(actor.class, "Warrior") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("switch", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Thief") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("pick lock", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Paladin") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("switch", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Antipaladin") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("switch", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Ranger") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("switch", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Assassin") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("pick lock", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Mercenary") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("switch", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Monk") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("switch", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Berserker") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("switch", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Rogue") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("pick lock", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        elseif string.find(actor.class, "Bard") then
            self:command("smile " .. tostring(actor.name))
            -- 
            local total = actor.level * 10 + 50
            actor.name:set_skill("pick lock", total)
            actor:save()
            actor.name:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        end
    else
        actor.name:send(self.name .. " tells you, '" .. "What do you want, go about your business." .. "'")
    end
end