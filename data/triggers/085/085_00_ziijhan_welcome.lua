-- Trigger: ziijhan_welcome
-- Zone: 85, ID: 0
-- Type: MOB, Flags: GREET
--
-- Greets newcomers based on their nec/dia/ant subclass quest stage,
-- and pitches the destiny hook to eligible warriors/clerics/sorcerers.
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
    local classgreet = "no"
    local maxlevel = 0
    if string.find(actor.class, "Warrior") then
        if actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
            maxlevel = 25
        end
    elseif string.find(actor.class, "Cleric") then
        if actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
            maxlevel = 35
        end
    elseif string.find(actor.class, "Sorcerer") then
        if actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
            maxlevel = 45
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
    -- TODO(parity): legacy phase_mace upgrade hook compared a quest stage
    -- against the literal string "macestep" and then multiplied that string
    -- by 10. The original DG used %macestep% as a numeric quest var; the
    -- conversion is corrupt. Reconstruct once phase_mace quest semantics
    -- are pinned down (likely: stage = current upgrade tier, minlevel = stage*10).
end  -- auto-close block