-- Trigger: academy_instructor_speech_communication
-- Zone: 519, ID: 81
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #51981

-- Converted from DG Script #51981: academy_instructor_speech_communication
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: communication
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "communication")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 1 then
    if actor:get_quest_var("school:speech") ~= "complete" then
        if (actor:get_quest_var("school:gear") and actor:get_quest_var("school:gear") ~= "complete") or (actor:get_quest_var("school:explore") and actor:get_quest_var("school:explore") ~= "complete") then
            actor:send(tostring(self.name) .. " tells you, 'You have to finish your other lesson first.'")
            return _return_value
        end
        if actor:get_quest_var("school:speech") then
            actor:send(tostring(self.name) .. " tells you, 'Let's resume your <b:yellow>COMMUNICATION</> lessons.'")
            wait(1)
        end
        -- switch on actor:get_quest_var("school:speech")
        if actor:get_quest_var("school:speech") == 2 then
            actor:send(tostring(self.name) .. " tells you, 'You can talk to one person at a time by using the <b:cyan>(T)ELL</> command.")
            actor:send("Only the person you TELL to will hear what you say.")
            actor:send("You can talk to anyone, anywhere in the world.")
            actor:send("You do it by typing <b:cyan>tell [person] [message]</>.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Try typing <b:green>tell instructor hello teacher</>.'")
        elseif actor:get_quest_var("school:speech") == 3 then
            actor:send(tostring(self.name) .. " tells you, 'Mass communication channels include:")
            -- (empty send to actor)
            actor:send("</><b:cyan>(GOS)SIP</> which talks to everyone in the game at once.")
            actor:send("</>   It's definitely the most popular communication channel.")
            actor:send("</>   It's a great way to ask questions or get help.")
            -- (empty send to actor)
            actor:send("</><b:cyan>(SH)OUT</> which talks to everyone in your zone.")
            -- (empty send to actor)
            actor:send("</><b:cyan>(PETI)TION</> which talks to all the Gods currently online.")
            actor:send("</>   It's best for asking semi-private or admin questions.")
            -- (empty send to actor)
            actor:send("</><b:cyan>GROUPSAY</> or <b:cyan>GSAY</> talks to everyone you're grouped with.")
            actor:send("</>   Check <b:cyan>HELP GROUP</> for more information on grouping.")
            -- (empty send to actor)
            actor:send("You can also use <b:cyan>LASTGOS</> and <b:cyan>LASTTEL</> to see what the last messages you received were.")
            -- (empty send to actor)
            actor:send("To see who's logged on, use the <b:cyan>WHO</> command.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Do you have any questions about communication?")
            actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
        elseif actor:get_quest_var("school:speech") == 1 then
        else
            actor:set_quest_var("school", "speech", 1)
            actor:send(tostring(self.name) .. " tells you, 'The most basic communication channel is the <b:cyan>(SA)Y</> command.")
            actor:send("It sends your message to everyone in the room.")
            actor:send("You'll need to use it to complete your lessons here.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Try it out.  <b:green>Say hello class</>.")
            actor:send("I'm listening for you to say exactly that, no extra words or punctuation.'")
        end
    end
end