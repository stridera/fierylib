-- Trigger: LP2_bard_subclass_speech1
-- Zone: 43, ID: 56
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4356

-- Converted from DG Script #4356: LP2_bard_subclass_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
    -- switch on actor.race
    do
        if actor:get_quest_stage("bard_subclass") == 0 then
            wait(0.2)
            if string.find(speech, "yes") then
                actor:start_quest("bard_subclass", "bar")
                actor:send(tostring(self.name) .. " says, 'Great!  From now on, you can check your <b:cyan>[subclass progress]</> with me.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'First, let's hear you <b:magenta>sing</>.'")
            else
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Come back if you want to go through with it.  My door is always open.'")
            end
        end
    end
end