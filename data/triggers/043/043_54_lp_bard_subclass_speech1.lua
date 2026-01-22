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
if string.find(actor.class, "Rogue") and (actor.level >= 10 and actor.level <= 25) then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- msend %actor% &1Your race cannot subclass to bard.&0
    -- halt
    -- break
    wait(2)
    if speech == "yes" then
        actor:send(tostring(self.name) .. " says, 'Right this way then!'")
        -- switch on actor:get_quest_stage("bard_subclass")
        if actor:get_quest_stage("bard_subclass") == 1 then
            local next = "Let's hear you &5&bsing&0!"
        elseif actor:get_quest_stage("bard_subclass") == 2 then
            local next = "Let's see you &5&bdance&0!"
        elseif actor:get_quest_stage("bard_subclass") == 3 or actor:get_quest_stage("bard_subclass") == 4 then
            local next = "Do you have the &3&bscript&0?"
        elseif actor:get_quest_stage("bard_subclass") == 5 then
            local next = "Let's hear some &6&bdialogue&0!"
        else
            local next = "So, let's discuss your &6&baudition&0."
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Seems like you got real star potential kid.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Follow me to the rehearsal studio.  We want you to audition for us.'")
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
            actor:send(tostring(self.name) .. " says, '" .. tostring(next) .. "'")
        end)
    else
        actor:send(tostring(self.name) .. " says, 'Too bad.  You have real start potential kid.  You could be big.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Huge!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Lemme know if you change your mind.  It's not too late for you.'")
    end
end