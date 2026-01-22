-- Trigger: LP2_bard_subclass_status_checker
-- Zone: 43, ID: 66
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #4366

-- Converted from DG Script #4366: LP2_bard_subclass_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
-- switch on actor:get_quest_stage("bard_subclass")
if actor:get_quest_stage("bard_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'You're at the <b:magenta>singing</> portion of your audition.'")
elseif actor:get_quest_stage("bard_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'You're at the <b:magenta>dancing</> portion of your audition.'")
elseif actor:get_quest_stage("bard_subclass") == 3 or actor:get_quest_stage("bard_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'You were looking for an old <b:yellow>script</> in Morgan Hill.'")
    if self.id == 4398 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Give it to me when you find it.'")
    end
elseif actor:get_quest_stage("bard_subclass") == 5 then
    actor:send(tostring(self.name) .. " says, 'Time to gimme some <b:cyan>dialogue</> work.  I sure hope you're off book!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'That means \"memorized\" in the business.'")
    self:command("wink " .. tostring(actor))
else
    if string.find(actor.class, "Rogue") then
        -- switch on actor.race
        -- case ADD RESTRICTED RACES HERE
        -- set classquest no
        if actor.level > 10 then
            actor:send(tostring(self.name) .. " says, 'You're a bit too green now, but come back soon!'")
        elseif actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'You haven't even started your audition yet!'")
            if self.id == 4399 then
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Say <b:cyan>'yes'</> if you're ready to continue.'")
            end
        else
            actor:send(tostring(self.name) .. " says, 'It's too late to start your career now buddy, sorry.'")
        end
    else
        local classquest = "no"
    end
    if classquest == "no" then
        actor:send(tostring(self.name) .. " says, 'You aren't cut out for a life on stage.'")
    end
end  -- auto-close block