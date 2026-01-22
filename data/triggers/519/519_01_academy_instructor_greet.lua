-- Trigger: academy_instructor_greet
-- Zone: 519, ID: 1
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #51901

-- Converted from DG Script #51901: academy_instructor_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor:get_quest_stage("school") == 1 then
    local speech = actor:get_quest_var("school:speech")
    local gear = actor:get_quest_var("school:gear")
    local explore = actor:get_quest_var("school:explore")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Greetings adventurer!  I'm your Intro to Adventuring instructor.  I teach the basics of <b:yellow>COMMUNICATION</>, <b:yellow>GEAR</>, and <b:yellow>EXPLORATION</>.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'It looks like you still need to complete lessons on:")
    if speech ~= "complete" then
        actor:send("<b:yellow>COMMUNICATION</>")
    end
    if gear ~= "complete" then
        actor:send("<b:yellow>GEAR</>")
    end
    if explore ~= "complete" then
        actor:send("<b:yellow>EXPLORATION</>")
    end
    actor:send("</>")
    actor:send("You can <b:green>say</> any of these to start a lesson on it or pick up where you left off.'")
    actor:send("</>")
    if speech ~= "complete" and (gear == "complete" or not gear) and (explore == "complete" or not explore) then
        actor:send(tostring(self.name) .. " tells you, 'If you're new to MUDs, I recommend you start with <b:yellow>COMMUNICATION</> by typing <b:green>say communication</>.'")
        actor:send("</>")
    end
    actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>SKIP</> to move on to the next instructor.'")
end