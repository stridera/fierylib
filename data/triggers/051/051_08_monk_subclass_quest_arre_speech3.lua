-- Trigger: monk_subclass_quest_arre_speech3
-- Zone: 51, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #5108

-- Converted from DG Script #5108: monk_subclass_quest_arre_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Warrior") then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- if %actor.level% >= 10 && %actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to monk.&0
    -- endif
    -- halt
    -- break
    if string.find(speech, "yes") then
        wait(2)
        if actor.level >= 10 then
            if actor:get_quest_stage("monk_subclass") == 0 then
                actor.name:start_quest("monk_subclass", "Mon")
                self:command("bow")
                actor:send(tostring(self.name) .. " says, 'It is wonderful to hear of others wanting to join the Brotherhood of the Monks.  You will be rewarded for your success with wonderful training, but only those pure of mind will complete the <b:cyan>quest</>.'")
                self.room:send("</>")
                actor:send(tostring(self.name) .. " says, 'You may ask about your <b:cyan>[subclass progress]</> or at any time.'")
            elseif actor:get_quest_stage("monk_subclass") == 2 then
                actor:send(tostring(self.name) .. " says, 'Thank you.  I'm certain those <b:cyan>fiends</> still have it.'")
            end
        elseif actor.level < 10 then
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
        else
            actor:send(tostring(self.name) .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
        end
    else
        wait(2)
        if actor:get_quest_stage("monk_subclass") == 0 then
            actor:send(tostring(self.name) .. " says, 'It is too bad then, we could use more in our ranks, but only if they truly wish to belong.'")
            self:command("smile")
        elseif actor:get_quest_stage("monk_subclass") == 2 then
            actor:send(tostring(self.name) .. " says, 'Then I am unwilling to continue your training.'")
        end
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Begone then.")
        actor:send("Your eyes blink repeatedly and you find yourself elsewhere.")
        self.room:send_except(actor, "There is a brief sparkle, and " .. tostring(actor.name) .. " is sent elsewhere.")
        actor:teleport(get_room(580, 1))
    end
end