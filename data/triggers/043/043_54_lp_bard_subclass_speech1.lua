-- Trigger: LP_bard_subclass_speech1
-- Zone: 43, ID: 54
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4354

-- Converted from DG Script #4354: LP_bard_subclass_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
    -- switch on actor.race
    do
        wait(0.2)
        if speech == "yes" then
            actor:send(tostring(self.name) .. " says, 'Right this way then!'")
            local next_line
            -- switch on actor:get_quest_stage("bard_subclass")
            do
                local _sw2 = string.lower(tostring(actor:get_quest_stage("bard_subclass") or ""))
                if tonumber(_sw2) == 1 then
                    next_line = "Let's hear you <b:magenta>sing</>!"
                elseif tonumber(_sw2) == 2 then
                    next_line = "Let's see you <b:magenta>dance</>!"
                elseif tonumber(_sw2) == 3 or tonumber(_sw2) == 4 then
                    next_line = "Do you have the <b:yellow>script</>?"
                elseif tonumber(_sw2) == 5 then
                    next_line = "Let's hear some <b:cyan>dialogue</>!"
                else
                    next_line = "So, let's discuss your <b:cyan>audition</>."
                    wait(0.2)
                    actor:send(tostring(self.name) .. " says, 'Seems like you got real star potential kid.'")
                    wait(2)
                    actor:send(tostring(self.name) .. " says, 'Follow me to the rehearsal studio.  We want you to audition for us.'")
                end
            end
            wait(2)
            actor:send(tostring(self.name) .. " escorts you backstage to a smaller dance studio.")
            self.room:send_except(actor, tostring(self.name) .. " escorts " .. tostring(actor.name) .. " backstage.")
            wait(2)
            actor:teleport(get_room(43, 69))
            -- actor looks around
            wait(2)
            actor:send(tostring(self.name) .. " settles in.")
            wait(1)
            get_room(43, 69):at(function()
                actor:send(tostring(self.name) .. " says, '" .. tostring(next_line) .. "'")
            end)
        else
            actor:send(tostring(self.name) .. " says, 'Too bad.  You have real start potential kid.  You could be big.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Huge!'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Lemme know if you change your mind.  It's not too late for you.'")
        end
    end
end