-- Trigger: start_quest_silania
-- Zone: 185, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 14 if statements
--
-- Original DG Script: #18503

-- Converted from DG Script #18503: start_quest_silania
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Cleric") then
    -- switch on actor.race
    if actor.level >= 10 and actor.level <= 35 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to priest.</>")
            return _return_value
        end
    else
        if actor.level >= 10 and actor.level <= 35 then
            local classquest = "yes"
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'I appreciate your virtue.  Come and see me once you've gained more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
        end
    end
end
if string.find(actor.class, "Warrior") then
    -- switch on actor.race
    if actor.level >= 10 and actor.level <= 25 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to paladin.</>")
            return _return_value
        end
    else
        if actor.level >= 10 and actor.level <= 25 then
            local classquest = "yes"
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'I appreciate your virtue.  Come and see me once you've gained more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
        end
    end
end
wait(2)
if classquest == "yes" then
    if string.find(speech, "yes") then
        if actor.alignment > 349 and not actor:get_quest_stage("pri_pal_subclass") then
            if not use_subclass then
                actor:send(tostring(self.name) .. " says, 'First, we must discuss your destiny.'")
            else
                actor.name:start_quest("pri_pal_subclass", use_subclass)
                self:command("smile " .. tostring(actor.name))
                actor:send(tostring(self.name) .. " says, 'You may check your <b:cyan>[subclass progress]</> or ask me to <b:cyan>[repeat]</> myself at any time.'")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'It is necessary to make a quest such as this quite tough to ensure ensure you really want to do this.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'I am sure you will complete the <b:cyan>quest</> though.'")
            end
        else
            actor:send(tostring(self.name) .. " says, 'I cannot help you if you are not good little one.'")
        end
    else
        self:command("sigh")
        actor:send(tostring(self.name) .. " says, 'It is a shame we have so few willing to join us these days, but I cannot compel you.  Farewell, and I hope you come to reconsider your decision sometime.'")
        wait(2)
        actor:send("Silania makes a gesture with her hand and you are blinded for a second.")
        self.room:send_except(actor, "Silania makes a gesture with her hand and " .. tostring(actor.name) .. " disappears.")
        actor:teleport(get_room(185, 66))
    end
    use_subclass = nil
end