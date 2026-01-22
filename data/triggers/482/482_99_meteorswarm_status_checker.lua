-- Trigger: meteorswarm_status_checker
-- Zone: 482, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #48299

-- Converted from DG Script #48299: meteorswarm_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: spell progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("meteorswarm")
wait(2)
if actor:get_quest_var("meteorswarm:new") ~= "yes" then
    actor:send(tostring(self.name) .. " says, 'Go find a new meteorite.'")
    return _return_value
elseif actor:get_quest_var("meteorswarm:new") ~= "no" then
    actor:send(tostring(self.name) .. " says, 'Show me the meteorite again.''")
    return _return_value
end
-- switch on stage
if stage == 1 then
    actor:send(tostring(self.name) .. " tells you, 'You need to find Jemnon and <b:cyan>ask about the rock demon</>.  He's in some <b:cyan>tavern</>, no doubt, waiting for some new blunder to embark on.'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " tells you, 'Find a suitable focus by defeating the rock demon in Templace.'")
    if actor:get_quest_var("meteorswarm:earth") == 0 then
    elseif stage == 3 then
        actor:send(tostring(self.name) .. " tells you, 'Show me the meteorite.'")
    else
        if actor:get_quest_var("meteorswarm:fire") == 0 then
            actor:send(tostring(self.name) .. " tells you, 'Find and kill the high fire priest in the Lava Tunnels.  Then enter the lava bubble below his secret chambers.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Find the lava bubble in the high fire priest's secret chambers.'")
        end
    end
    wait(1)
    actor:send(tostring(self.name) .. " says, 'If you somehow lost the meteorite, say <b:red>\"I lost the meteorite\"</>.'")
elseif stage == 4 then
    actor:send(tostring(self.name) .. " tells you, 'Convince the ancient dragon Dargentan to teach you the ways of air magic.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'If you somehow lost the meteorite, say <b:red>\"I lost the meteorite\"</>.'")
    if actor:get_quest_var("meteorswarm:air") == 0 then
    elseif stage == 5 then
        actor:send(tostring(self.name) .. " tells you, 'Show me the meteorite now that you have mastered earth, fire, and air.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'If you somehow lost the meteorite, say <b:red>\"I lost the meteorite\"</>.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Take your finished focus and unleash its potential!'")
    end
end