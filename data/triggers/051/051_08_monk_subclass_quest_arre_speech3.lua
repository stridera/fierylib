-- Trigger: monk_subclass_quest_arre_speech3
-- Zone: 51, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5108
--
-- Yes/no answer to Arre's "are you certain you wish to study as a monk"
-- prompt from speech2 (51/7). Yes -> start the quest (or restart at the
-- sash-recovery checkpoint, stage 2). No -> dismiss the player back to
-- the temple entrance (580/1).
--
-- TODO(parity): legacy DG had a placeholder for restricted races
-- ("ADD RESTRICTED RACES HERE") which was never filled in.

-- Speech keywords: yes, no
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "no")) then
    return true  -- No matching keywords
end
if not string.find(actor.class, "Warrior") then
    return  -- Non-warriors silently ignored, matching legacy DG
end
local stage = actor:get_quest_stage("monk_subclass")
if string.find(speech_lower, "yes") then
    wait(2)
    if actor.level < 10 then
        self:command("eye " .. actor.name)
        actor:send(self.name .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
    elseif actor.level <= 25 then
        if stage == nil or stage == 0 then
            actor:start_quest("monk_subclass")
            self:command("bow")
            actor:send(self.name .. " says, 'It is wonderful to hear of others wanting to join the Brotherhood of the Monks.  You will be rewarded for your success with wonderful training, but only those pure of mind will complete the <b:cyan>quest</>.'")
            self.room:send("</>")
            actor:send(self.name .. " says, 'You may ask about your <b:cyan>[subclass progress]</> or at any time.'")
        elseif stage == 2 then
            actor:send(self.name .. " says, 'Thank you.  I'm certain those <b:cyan>fiends</> still have it.'")
        end
    else
        actor:send(self.name .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
    end
else
    wait(2)
    if stage == nil or stage == 0 then
        actor:send(self.name .. " says, 'It is too bad then, we could use more in our ranks, but only if they truly wish to belong.'")
        self:command("smile")
    elseif stage == 2 then
        actor:send(self.name .. " says, 'Then I am unwilling to continue your training.'")
    end
    wait(1)
    actor:send(self.name .. " says, 'Begone then.")
    actor:send("Your eyes blink repeatedly and you find yourself elsewhere.")
    self.room:send_except(actor, "There is a brief sparkle, and " .. actor.name .. " is sent elsewhere.")
    actor:teleport(get_room(580, 1))
end