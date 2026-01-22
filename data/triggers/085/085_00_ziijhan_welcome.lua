-- Trigger: ziijhan_welcome
-- Zone: 85, ID: 0
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #8500

-- Converted from DG Script #8500: ziijhan_welcome
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("nec_dia_ant_subclass")
if actor:get_quest_stage("nec_dia_ant_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'So you come crawling back.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Only the most cunning and strong will complete the <magenta>quest</> I set before you.  I shall take great pleasure in your demise, but I will offer great rewards for your success.'")
elseif actor:get_quest_stage("nec_dia_ant_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'It is time to hunt!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'My pitiful waste of a <magenta>brother</> escaped my minions.'")
elseif actor:get_quest_stage("nec_dia_ant_subclass") == 3 or actor:get_quest_stage("nec_dia_ant_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Have you brought proof that my brother is not beyond my reach?'")
else
    if string.find(actor.class, "Warrior") then
        -- switch on actor.race
        if actor.race == "elf" or actor.race == "faerie_seelie" then
            local classgreet = "no"
        else
            local classgreet = "yes"
            local maxlevel = 25
        end
    elseif string.find(actor.class, "Cleric") then
        -- switch on actor.race
        if actor.race == "elf" or actor.race == "faerie_seelie" then
            local classgreet = "no"
        else
            local classgreet = "yes"
            local maxlevel = 35
        end
    elseif string.find(actor.class, "Sorcerer") then
        -- switch on actor.race
        if actor.race == "elf" or actor.race == "faerie_seelie" then
            local classgreet = "no"
        else
            local classgreet = "yes"
            local maxlevel = 45
        end
    end
    if classgreet == "yes" then
        if actor.level >= 10 and actor.level <= maxlevel then
            self:command("peer " .. tostring(actor.name))
            self:emote("places a most vile half-smile on his face.")
            actor:send(tostring(self.name) .. " says, 'Some know not of their <magenta>destinies</>, while others simply choose to ignore them.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Which of the two are you?'")
            self:command("glare " .. tostring(actor.name))
        end
    end
    if actor:get_quest_stage("phase_mace") == "macestep" then
        local minlevel = macestep * 10
        if actor.level >= minlevel then
            if actor:get_quest_var("phase_mace:greet") == 0 then
                actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
            end
        end
    end
end  -- auto-close block