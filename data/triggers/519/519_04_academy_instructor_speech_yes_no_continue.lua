-- Trigger: academy_instructor_speech_yes_no_continue
-- Zone: 519, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 13 if statements
--
-- Original DG Script: #51904

-- Converted from DG Script #51904: academy_instructor_speech_yes_no_continue
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no continue
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no") or string.find(string.lower(speech), "continue")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 1 then
    if speech == "yes" then
        if actor:get_quest_var("school:speech") == 3 then
            actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
            actor:send("<b:yellow>Say</>")
            actor:send("<b:yellow>Tell</>")
            actor:send("<b:yellow>Gossip</>_")
            actor:send("I'll know you're ready to move on if you <b:green>say continue</>.'")
        elseif actor:get_quest_var("school:gear") == 16 then
            actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
            actor:send("<b:yellow>Inventory</>")
            actor:send("<b:yellow>Wear</>")
            actor:send("<b:yellow>Equipment</>")
            actor:send("<b:yellow>Light</>")
            actor:send("<b:yellow>Remove</>")
            actor:send("<b:yellow>Get</>")
            actor:send("<b:yellow>Drop</>")
            actor:send("<b:yellow>Junk</>")
            actor:send("<b:yellow>Give</>")
            actor:send("<b:yellow>Put</>_")
            actor:send("I'll know you're ready to move on if you <b:green>say continue</>.'")
        elseif actor:get_quest_var("school:explore") == 6 then
            actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
            actor:send("<b:yellow>Look</>")
            actor:send("<b:yellow>Search</>")
            actor:send("<b:yellow>Doors</>")
            actor:send("<b:yellow>Scan</>")
            actor:send("<b:yellow>Movement</>_")
            actor:send("I'll know you're ready to move on if you <b:green>say continue</>.'")
        end
    else
        if actor:get_quest_var("school:speech") == 3 then
            actor:set_quest_var("school", "speech", "complete")
        elseif actor:get_quest_var("school:gear") == 16 then
            actor:set_quest_var("school", "gear", "complete")
        elseif actor:get_quest_var("school:explore") == 6 then
            actor:set_quest_var("school", "explore", "complete")
        end
        if actor:get_quest_var("school:speech") == "complete" and actor:get_quest_var("school:gear") == "complete" and actor:get_quest_var("school:explore") == "complete" then
            local advance = "yes"
        else
            local advance = "no"
        end
        if advance == "yes" then
            actor:advance_quest("school")
            actor:send(tostring(self.name) .. " tells you, 'Then you're ready to move on!")
            actor:send("Proceed <b:green>east</>.")
            actor:send("In the next room you'll prepare for combat training!'")
        elseif advance == "no" then
            actor:send(tostring(self.name) .. " tells you, 'It looks like you still need to complete lessons on:")
            if actor:get_quest_var("school:speech") ~= "complete" then
                actor:send("<b:yellow>COMMUNICATION</>")
            end
            if actor:get_quest_var("school:gear") ~= "complete" then
                actor:send("<b:yellow>GEAR</>")
            end
            if actor:get_quest_var("school:explore") ~= "complete" then
                actor:send("<b:yellow>EXPLORATION</>")
            end
            actor:send("</>")
            actor:send("You can <b:green>say</> any of these to start a lesson on it or say <magenta>SKIP</> to move on to the next teacher.'")
        end
    end
end