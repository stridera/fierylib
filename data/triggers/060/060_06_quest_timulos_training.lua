-- Trigger: quest_timulos_training
-- Zone: 60, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6006

-- Converted from DG Script #6006: quest_timulos_training
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: training
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "training")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "Rogue") then
    if actor.level >= 10 and actor.level <= 25 then
        if not use_subclass then
            self:command("nod " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Well which would you like to train as: <yellow>mercenary</>, <red>assassin</>, or <b:red>thief</>?'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Say one of them.'")
        else
            actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
            actor:send(tostring(self.name) .. " ushers you into the corner.")
            self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Wait there.'")
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you to subclass, kid.'")
    else
        actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
    end
else
    actor:send(tostring(self.name) .. " says, 'Go find someone else to train with.'")
    wait(2)
    -- this may need to be changed in the future if new classes are invented that aren't just <name>s for pluralizing.
    actor:send(tostring(self.name) .. " says, 'I don't work with " .. tostring(actor.class) .. "s.'")
end