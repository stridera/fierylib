-- Trigger: start_quest_ziijhan
-- Zone: 85, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #8502

-- Converted from DG Script #8502: start_quest_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Cleric") and actor.level >= 10 and actor.level <= 35 then
    -- switch on actor.race
    if actor.race == "elf" or actor.race == "faerie_seelie" then
        actor:send("<red>Your race may not subclass to diabolist.</>")
        return _return_value
    else
        local classquest = 1
    end
elseif string.find(actor.class, "Warrior") and actor.level >= 10 and actor.level <= 25 then
    -- switch on actor.race
    if actor.race == "elf" or actor.race == "faerie_seelie" then
        actor:send("<red>Your race may not subclass to anti-paladin.</>")
        return _return_value
    else
        local classquest = 1
    end
elseif string.find(actor.class, "Sorcerer") and actor.level >= 10 and actor.level <= 45 then
    -- switch on actor.race
    if actor.race == "elf" or actor.race == "faerie_seelie" then
        actor:send("<red>Your race may not subclass to necromancer.</>")
        return _return_value
    else
        local classquest = 1
    end
end
if classquest == 1 then
    if string.find(speech, "yes") then
        if actor:get_quest_stage("nec_dia_ant_subclass") == 0 then
            actor.name:start_quest("nec_dia_ant_subclass", use_subclass)
        end
        use_subclass = nil
        wait(2)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'Only the most cunning and strong will complete the <magenta>quest</> I set before you.  I shall take great pleasure in your demise, but I will offer great rewards for your success.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I can update you on your <magenta>[subclass progress]</> as well.'")
    elseif string.find(speech, "no") then
        use_subclass = nil
        actor:send(tostring(self.name) .. " says, 'Begone from my sight before I lose patience with you!'")
        self:command("whap " .. tostring(actor.name))
        actor:send("Ziijhan waves his arms in a circle and you are blinded by a flash of light!")
        self.room:send_except(actor, "Ziijhan glares at " .. tostring(actor.name) .. " and sends " .. tostring(actor.object) .. " elsewhere!")
        actor:teleport(get_room(85, 1))
    end
end