-- Trigger: LP2_bard_subclass_status_checker
-- Zone: 43, ID: 66
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4366

-- Converted from DG Script #4366: LP2_bard_subclass_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(0.2)
-- switch on actor:get_quest_stage("bard_subclass")
do
    local _sw1 = string.lower(tostring(actor:get_quest_stage("bard_subclass") or ""))
    if tonumber(_sw1) == 1 then
        actor:send(tostring(self.name) .. " says, 'You're at the <b:magenta>singing</> portion of your audition.'")
    elseif tonumber(_sw1) == 2 then
        actor:send(tostring(self.name) .. " says, 'You're at the <b:magenta>dancing</> portion of your audition.'")
    elseif tonumber(_sw1) == 3 or tonumber(_sw1) == 4 then
        actor:send(tostring(self.name) .. " says, 'You were looking for an old <b:yellow>script</> in Morgan Hill.'")
        if (self.zone_id == 43 and self.id == 98) then
            wait(0.2)
            actor:send(tostring(self.name) .. " says, 'Give it to me when you find it.'")
        end
    elseif tonumber(_sw1) == 5 then
        actor:send(tostring(self.name) .. " says, 'Time to gimme some <b:cyan>dialogue</> work.  I sure hope you're off book!'")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'That means \"memorized\" in the business.'")
        self:command("wink " .. tostring(actor))
    else
        local classquest
        if string.find(actor.class, "rogue") then
            -- switch on actor.race
            do
                if actor.level > 10 then
                    actor:send(tostring(self.name) .. " says, 'You're a bit too green now, but come back soon!'")
                elseif actor.level >= 10 and actor.level <= 25 then
                    actor:send(tostring(self.name) .. " says, 'You haven't even started your audition yet!'")
                    if (self.zone_id == 43 and self.id == 99) then
                        wait(0.2)
                        actor:send(tostring(self.name) .. " says, 'Say <b:cyan>'yes'</> if you're ready to continue.'")
                    end
                else
                    actor:send(tostring(self.name) .. " says, 'It's too late to start your career now buddy, sorry.'")
                end
            end
        else
            classquest = "no"
        end
        if classquest == "no" then
            actor:send(tostring(self.name) .. " says, 'You aren't cut out for a life on stage.'")
        end
    end
end