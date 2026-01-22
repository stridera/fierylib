-- Trigger: quest_eleweiss_ranger_druid_subclass_speak1
-- Zone: 163, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16302

-- Converted from DG Script #16302: quest_eleweiss_ranger_druid_subclass_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: ways woods
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "ways") or string.find(speech_lower, "woods") or string.find(speech_lower, "i know")) then
    return true  -- No matching keywords
end
if (string.find(speech_lower, "ways") or string.find(speech_lower, "woods") or string.find(speech_lower, "i know")) and not actor:get_quest_stage("ran_dru_subclass") then
    if string.find(actor.class, "Cleric") then
        -- switch on actor.race
        -- case ADD NEW RESTRICTED RACES HERE
        -- if %actor.level% >= 10 && %actor.level% <= 35
        -- msend %actor% &1Your race may not subclass to druid.&0
        -- halt
        -- endif
        -- break
        wait(2)
        if actor.level >= 10 and actor.level <= 35 then
            if use_subclass then
                actor:send(tostring(self.name) .. " says, 'I'm currently assisting someone else, one moment please.'")
                return _return_value
            end
            if actor.alignment > -350 and actor.alignment < 350 then
                self:command("smile " .. tostring(actor.name))
                actor:send(tostring(self.name) .. " says, 'Do you wish to join the ranks of the woodland healers with all the power there of?'")
                local use_subclass = "Dru"
                globals.use_subclass = globals.use_subclass or true
            else
                actor:send(tostring(self.name) .. " says, 'You are not properly aligned to be a woodland cleric.  Come back when you fix that.'")
            end
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    elseif string.find(actor.class, "Warrior") then
        -- switch on actor.race
        -- case ADD NEW RESTRICTED RACES HERE
        -- if %actor.level% >= 10 && %actor.level% <= 25
        -- msend %actor% &1Your race may not subclass to ranger.&0
        -- halt
        -- endif
        -- break
        wait(2)
        if actor.level >= 10 and actor.level <= 25 then
            if use_subclass then
                actor:send(tostring(self.name) .. " says, 'I'm currently assisting someone else, one moment please.'")
                return _return_value
            end
            if actor.alignment > 349 then
                self:command("nod " .. tostring(actor.name))
                actor:send(tostring(self.name) .. " says, 'Do you wish to become a fighter who is one with the forests?'")
                local use_subclass = "Ran"
                globals.use_subclass = globals.use_subclass or true
            else
                actor:send(tostring(self.name) .. " says, 'Sorry, your alignment is not proper for what you wish to be.  Try again later.'")
            end
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    else
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I can do nothing for you, I am sorry.'")
        self:emote("smiles a little bit.")
    end
end